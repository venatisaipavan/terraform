terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {
  #region = "ap-south-1"

}

resource "aws_instance" "Create_instance" {
  ami = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.securitygroup1.id]

  tags = {
    Name = "firstVM"
    owner = "Saipavan"
    Environment = "dev"
  }
}

resource "aws_vpc" "Terraform_1_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ter_vpc1"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.Terraform_1_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}
resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.Terraform_1_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "securitygroup1" {
 vpc_id = aws_vpc.Terraform_1_vpc.id  
ingress {
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "-1"
}
egress {
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "-1"
}
}

resource "aws_internet_gateway" "terint_1" {
  vpc_id = aws_vpc.Terraform_1_vpc.id

  tags = {
    Name = "ter1_igw"
  }
  
}

resource "aws_route" "terrou1" {
  gateway_id = aws_internet_gateway.terint_1.id
  route_table_id = aws_vpc.Terraform_1_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"

}
