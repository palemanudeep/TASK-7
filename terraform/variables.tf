variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.large"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0000791bad666add5"
}

variable "key_name" {
  description = "Key pair name"
  default     = "new"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for Subnet"
  default     = "10.0.1.0/24"
}
