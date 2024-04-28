provider "aws" {
  region = "ap-southeast-2"
  profile = "default"
}

terraform {
  required_version = ">= 0.12.0"
}

# data "aws_vpc" "stagingtest" {
#   id = var.vpc_id
# }

# data "aws_subnets" "dest" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.stagingtest.id]
#   }
#   filter {
#     name   = "tag:Name"
#     values = "public-ap-southeast-2b"
#   }  

# }

# data "aws_subnet" "dest" {
#   for_each = toset(data.aws_subnets.dest.ids)
#   id       = each.value
# }

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.dest : s.cidr_block]
# }
          
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

# resource "aws_instance" "ec2" {
#   ami           = data.aws_ami.ubuntu.image_id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.dest.id

#   tags = {
#     Name = "pygitactionec2"
#   }
# }

# instance identity
resource "aws_instance" "pygitactionec2" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = lookup(var.awsprops, "subnet")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")


  # security group
  vpc_security_group_ids = [
    aws_security_group.pygitactionec2-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 40
    volume_type           = "gp2"
  }
  tags = {
    Name        = "pygitactionec2"
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "TF"
  }

  provisioner "file" {
    source      = "installer.sh"
    destination = "/tmp/installer.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/installer.sh",
      "sh /tmp/installer.sh"
    ]

  }
  depends_on = [aws_security_group.pygitactionec2-sg]

# connecting to AWS instance to install jenkins and docker
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("./pygitactionec2-key.pem")
  }
}


output "ec2instance" {
  value = aws_instance.pygitactionec2.public_ip
}


// AMI Security group setting using HashiCorp Configuration Language (HCL)
resource "aws_security_group" "pygitactionec2-sg" {
  name        = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id      = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_tls"
  }

  lifecycle {
    create_before_destroy = false
  }
}