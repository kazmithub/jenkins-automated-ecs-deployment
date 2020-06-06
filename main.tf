provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"
  namePrefix = "${var.namePrefix}"
}

module "ec2" {
  source = "./modules/ec2"
  sgec2 = "${module.vpc.sgec2}"
  subnetId = "${module.vpc.subnetId}"
  namePrefix = "${var.namePrefix}"
}
