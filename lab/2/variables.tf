variable "instance_type" {
  default = "t2.micro"
}

variable "aws" {
  type = map
  default = {
    access_key = ""
    secret_key = ""
  }
}
