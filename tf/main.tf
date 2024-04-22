provider "aws" {
  region = "ap-southeast-2"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "stagingtest" {
  default = true  //vpc-0a09686505f2c4051
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.stagingtest.id
}