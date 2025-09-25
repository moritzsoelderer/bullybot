variable "aws_region" {
  description = "Desired AWS region"
  default = "eu-north-1"
}

variable "instance_type" {
  description = "type of AWS instance one likes to create"
  default = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of your AWS ssh key-pair"
  default = "terraform-key-pair"
}