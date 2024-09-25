terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.3"
}

provider "aws" {
  region = "ap-south-1"  # Permanent AWS region
}

# Create a new VPC
resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MedusaVPC"
  }
}

# Create subnets
resource "aws_subnet" "medusa_subnet" {
  vpc_id                  = aws_vpc.medusa_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "MedusaSubnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "medusa_igw" {
  vpc_id = aws_vpc.medusa_vpc.id

  tags = {
    Name = "MedusaIGW"
  }
}

# Create a Route Table
resource "aws_route_table" "medusa_route_table" {
  vpc_id = aws_vpc.medusa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.medusa_igw.id
  }

  tags = {
    Name = "MedusaRouteTable"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "medusa_rta" {
  subnet_id      = aws_subnet.medusa_subnet.id
  route_table_id = aws_route_table.medusa_route_table.id
}

# Create a Security Group
resource "aws_security_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id

  ingress {
    from_port   = 22    # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000   # Medusa
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7001   # Medusa
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MedusaSG"
  }
}

# Create an EC2 Instance
resource "aws_instance" "medusa_instance" {
  ami             = "ami-0000791bad666add5"  # Your specified AMI
  instance_type   = "t2.large"                # Your instance type
  key_name        = "new"                     # Your key pair name

  subnet_id       = aws_subnet.medusa_subnet.id
  security_groups = [aws_security_group.medusa_sg.name]

  root_block_device {
    volume_size = 16  # 16 GB storage
    volume_type = "gp2"  # General Purpose SSD
  }

  tags = {
    Name = "MedusaInstance"
  }
}

# Create ECR Repository
resource "aws_ecr_repository" "medusa_repository" {
  name = "medusa-ecr-new"  # Your ECR repository name
}

output "ec2_public_ip" {
  value = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.medusa_repository.repository_url
}
