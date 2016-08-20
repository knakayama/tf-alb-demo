variable "name" {}

variable "vpc_cidr" {}

variable "spot_config" {
  type = "map"
}

variable "alb_config" {
  type = "map"
}

variable "azs" {
  type = "list"
}

variable "amazon_linux_id" {}
