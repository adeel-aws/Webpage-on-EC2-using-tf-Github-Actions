provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-2k26"
    key     = "static-website/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# VPC and Subnets 
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name = "My-VPC" }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.Availability_zone1
  map_public_ip_on_launch = true 
  tags = { Name = "Public-Subnet1" }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = { Name = "My-IGW" }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt.id
}

# Security Group: Now GitHub Actions Friendly
resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.my-vpc.id
  name        = "web-sg"

  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_location] 
  }

  ingress {
    description = "Public HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ADD THIS BLOCK HERE
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "webserver" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public-subnet1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = { Name = "static by tf & CI/CD" }
}