provider "aws" {
  region = "ap-southeast-2"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "stagingtest" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.stagingtest.id
}

resource "aws_ecr_repository" "cs" {
  name                 = "counter-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
