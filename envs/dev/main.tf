provider "aws" {
  region = "${var.region}"
}

module "dev" {
  source = "../.."

  name            = "${var.name}"
  vpc_cidr        = "${var.vpc_cidr}"
  spot_config     = "${var.spot_config}"
  alb_config      = "${var.alb_config}"
  azs             = "${data.aws_availability_zones.az.names}"
  amazon_linux_id = "${data.aws_ami.amazon_linux.id}"
}
