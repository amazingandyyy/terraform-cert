# Certified Terraform

## Configuration management vs Infrastrucure as code(IAC)

IAS is a provisioners, which can use configuration management tool such as Ansible.

## Basic

```sh
instance.tf
variable.tf
terraform.tfvars // ignored
modules/
```

### Commands

```shell
terraform init // it will download plugins for providers
terraform plan // list out what to do
terraform apply // do the job
terraform destroy
terraform destroy -target aws_instance.myec2
terraform refresh // will fetch current state from AWS and update `.tfstate` files
terraform show // show current tfstate
terraform console // try out functions
terraform fmt // format
terraform validate
terraform taint // destroy that item and recreate it again
terraform workspace show|list|select
```

## Variables

- create variables with variables.tf file or do either following to override
  - explicitly set with `-var='key=valu'` flag
  - use `terraform.tfvars` file
  - use `custommmm.tfvars` and `-var-file='custommmm.tfvars` flag
  - use `export TF_VAR_instance_type="m5.large"` enviroment variable
- you can define variables types, types can be string, list, map, number
```sh
variable "access_key" {
  type = number
}
```

### Points

- TF use `terraform.tfstate` file to store curent state
- if someone went to AWS interface to change something, terraform plan will catch that current state is different from desired state(in the `.tf` files)
- if the state on AWS is not a part of the definition then it will not know the shape of the current state
- providers have different versions, should better explicitly set the provider version in tf files. (`>=`, `~>`, `<=`)
- third party providers should be downloaded and copy to `~/.terraform.d/plugins` to make it available
- you can have output in the tf file
- use count and count.index and list variable to iterate and generate dynamic names
- conditional expression
- local values
- terraform [functions](https://www.terraform.io/docs/configuration/functions.html)
  - max(), element(), lookup(), file("${path.module}"), formatdate("DD MMMM YYYY hh:mm:ss ZZZ", timestamp())

- data source: data block, fetch data from owner
```sh
data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
```

- debugging: set TF_LOG to either TRACE(default), DEBUG, INFO, WARN, or ERROR
  - can also set TF_LOG_PATH to /tmp/terraform-crash.log
- dynamic block, iterator is optional alternative name
```sh
variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8200, 8201,8300, 9200, 9500]
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

## [Provisioner](https://www.terraform.io/docs/provisioners/index.html)

- to execute scripts on a machine
  - local-exec // run on the machine whichever run the terraform apply command
  - remote-exec // run on the created remote machine
```sh
resource "aws_instance" "web" {
  # ...

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
- [connection](https://www.terraform.io/docs/provisioners/connection.html)
  - using self.public_ip
- use case
  - run ansible as local-exec

## Modules

- use source to use any tf file to be a module
- using variable and default value to make modules' value overridable, otherwise cannot be overwritten at all
- terragorm registry
  - modules written by community
  - `module` [e.g](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.33.0)

## Workspace

- lookup
```sh

resource "aws_instance" "myec2" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = lookup(var.instance_type,terraform.workspace)
}

variable "instance_type" {
  type = "map"

  default = {
    default = "t2.nano"
    dev     = "t2.micro"
    prd     = "t2.large"
  }
}
```
- the .fstate will be created into `terraform.tfstate.d`

