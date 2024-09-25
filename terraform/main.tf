provider "aws" {
  region = "ap-south-1"  # Permanent AWS region
}

resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "medusa_subnet" {
  vpc_id            = aws_vpc.medusa_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_security_group" "medusa_sg" {
  name        = "medusa_security_group"
  description = "Allow inbound traffic for Medusa application"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7001
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
}

resource "aws_instance" "medusa_instance" {
  ami           = "ami-0000791bad666add5"  # Ubuntu AMI ID
  instance_type = "t2.large"  # Large instance with 15 GB of memory
  subnet_id     = aws_subnet.medusa_subnet.id
  key_name      = "new"  # Key pair name (without .pem)

  vpc_security_group_ids = [aws_security_group.medusa_sg.id]

  tags = {
    Name = "MedusaInstance"
  }
}

resource "aws_ecr_repository" "medusa_repository" {
  name = "medusa-ecr"
}

output "ec2_public_ip" {
  value = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.medusa_repository.repository_url
}
