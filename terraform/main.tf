resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "medusa-vpc"
  }
}

resource "aws_subnet" "medusa_subnet" {
  vpc_id            = aws_vpc.medusa_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "medusa-subnet"
  }
}

resource "aws_security_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access to Medusa
  }

  ingress {
    from_port   = 7001
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access to Medusa
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
  }

  tags = {
    Name = "medusa-sg"
  }
}

resource "aws_instance" "medusa_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.medusa_subnet.id

  root_block_device {
    volume_size = var.instance_storage  # 16 GB
    volume_type = "gp2"  # General Purpose SSD
  }

  tags = {
    Name = "medusa-instance"
  }
}

resource "aws_ecr_repository" "medusa_ecr" {
  name = var.ecr_repository_name
}

output "ec2_public_ip" {
  value = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.medusa_ecr.repository_url
}
