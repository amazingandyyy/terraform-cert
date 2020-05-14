provider "aws" {
  region     = "us-west-2"
  access_key = var.aws["access_key"]
  secret_key = var.aws["secret_key"]
  version    = ">= 2.7"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0d6621c01e8c2de2c"
  instance_type = var.instance_type
}

resource "aws_eip" "lb" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

resource "aws_security_group" "allow_tls" {
  name = "allow-tls-sg"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"]
  }
}
