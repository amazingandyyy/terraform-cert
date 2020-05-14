provider "aws" {
  region     = "us-west-2"
  access_key = var.aws["access_key"]
  secret_key = var.aws["secret_key"]
  version    = ">= 2.7"
}

resource "aws_instance" "myec2" {
   ami = "ami-0d6621c01e8c2de2c"
   instance_type = "t2.micro"
}
