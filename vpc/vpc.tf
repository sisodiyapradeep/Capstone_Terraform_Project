resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name    = "${var.project}-vpc"
    Project = var.project
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project}-vpc-subnet-a"
  }
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.project}-vpc-subnet-b"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-vpc-ig"
  }
}

resource "aws_default_route_table" "rt" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  default_route_table_id = aws_vpc.vpc.default_route_table_id
}


variable "project" {
  description = "The name of the current project."
  type        = string
  default     = "My Project"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_a_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "subnet_b_cidr" {
  type    = string
  default = "10.10.2.0/24"
}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet-a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet-b.id
}