
# variable "vpc_id" {
#   description = "id of vpc"
#   type        = string
#   default      = "vpc-08112924827b29757"
# }

variable "awsprops" {
  type = map(any)
  default = {
    region       = "ap-southeast-2"
    vpc          = "vpc-08112924827b29757"
    ami          = "ami-080660c9757080771"
    itype        = "t2.micro"
    subnet       = "subnet-0273c400b9d31a60f"
    publicip     = true
    keyname      = "pygitactionec2-key"
    secgroupname = "pygitactionec2-sg"
  }
}

variable "ingress_rules" {
  default = {
    "my ingress rule" = {
      "description" = "For HTTP"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "my other ingress rule" = {
      "description" = "For SSH"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Postgres port" = {
      "description" = "For HTTP postgres"
      "from_port"   = "5432"
      "to_port"     = "5432"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Jenkins port" = {
      "description" = "For Jenkins"
      "from_port"   = "8080"
      "to_port"     = "8080"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

     "React Application port" = {
      "description" = "For React"
      "from_port"   = "3000"
      "to_port"     = "3000"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Django Application port" = {
      "description" = "For Django"
      "from_port"   = "8585"
      "to_port"     = "8585"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
     "Django alt Application port" = {
      "description" = "For Django alt port"
      "from_port"   = "8000"
      "to_port"     = "8000"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }

    "All Ports" = {
      "description" = "For HTTP all ports"
      "from_port"   = "3000"
      "to_port"     = "65535"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
  }
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Security group rules"
}

# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }

# variable "instance_ami" {
#   description = "AMI ID for the EC2 instance"
#   type        = string
#   default     = ""
# }

# variable "instance_vpc_id" {
#   type    = string
#   default = ""
# }

# variable "instance_subnet_id" {
#   type    = string
#   default = ""
# }

# variable "instance_keyName" {
#   type    = string
#   default = "pygitactionec2-key"
# }

# variable "instance_secgroupname" {
#   description = "This is a security Group Name"
#   type        = string
#   default     = "pygitactionec2-sg"
# }

# variable "instance_publicip" {
#   type    = bool
#   default = true
# }
