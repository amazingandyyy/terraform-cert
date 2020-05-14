# Certified Terraform

## Configuration management vs Infrastrucure as code(IAC)

IAS is a provisioners, which can use configuration management tool such as Ansible.

### Commands

```shell
terraform init // it will download plugins for providers
terraform plan
terraform apply
terraform destroy
terraform destroy -target aws_instance.myec2
terraform refresh // will fetch current state from AWS and update `.tfstate` files
terraform show // show current tfstate
```

### Points

- TF use `terraform.tfstate` file to store curent state
- if someone went to AWS interface to change something, terraform plan will catch that current state is different from desired state(in the `.tf` files)
- if the state on AWS is not a part of the definition then it will not know the shape of the current state
- providers have different versions, should better explicitly set the provider version in tf files. (`>=`, `~>`, `<=`)
- third party providers should be downloaded and copy to `~/.terraform.d/plugins` to make it available
- you can have output in the tf file
