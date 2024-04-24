provider "aws" {
  region = "ap-southeast-2"
  profile = "default"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "stagingtest" {
  id = var.vpc_id
}

data "aws_subnets" "dest" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.stagingtest.id]
  }
  filter {
    name   = "tag:Name"
    values = "public-ap-southeast-2b"
  }  

}

data "aws_subnet" "dest" {
  for_each = toset(data.aws_subnets.dest.ids)
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.dest : s.cidr_block]
}
          
resource "aws_ecr_repository" "cs" {
  name                 = "pygitactionec2"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}


data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    #owners = ["099720109477"]
}

output "latest" {
  value = data.aws_ami.ubuntu
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.dest.id

  tags = {
    Name = "pygitactionec2"
  }
}