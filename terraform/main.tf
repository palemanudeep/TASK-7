provider "aws" {
  region = "ap-south-1"  # Permanent AWS region
}

resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "medusa-vpc"
  }
}

resource "aws_subnet" "medusa_subnet" {
  vpc_id            = aws_vpc.medusa_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "medusa-subnet"
  }
}

resource "aws_internet_gateway" "medusa_igw" {
  vpc_id = aws_vpc.medusa_vpc.id
  tags = {
    Name = "medusa-igw"
  }
}

resource "aws_route_table" "medusa_route_table" {
  vpc_id = aws_vpc.medusa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.medusa_igw.id
  }

  tags = {
    Name = "medusa-route-table"
  }
}

resource "aws_route_table_association" "medusa_route_table_association" {
  subnet_id      = aws_subnet.medusa_subnet.id
  route_table_id = aws_route_table.medusa_route_table.id
}

resource "aws_security_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "medusa-sg"
  }
}

resource "aws_instance" "medusa_instance" {
  ami           = "ami-0000791bad666add5"  # Ubuntu AMI
  instance_type = "t2.large"
  key_name      = "new"  # EC2 Key Pair name
  subnet_id     = aws_subnet.medusa_subnet.id
  security_groups = [aws_security_group.medusa_sg.name]

  root_block_device {
    volume_size = 16  # 16 GB storage
  }

  tags = {
    Name = "medusa-instance"
  }
}

resource "aws_ecr_repository" "medusa_repo" {
  name = "medusa-ecr-new"

  tags = {
    Name = "medusa-ecr"
  }
}

output "ec2_public_ip" {
  value = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.medusa_repo.repository_url
}
