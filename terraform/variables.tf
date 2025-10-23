variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "key_name" {
  type    = string
  default = "easypay-key"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/easypay_key.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "worker_count" {
  type    = number
  default = 2
}