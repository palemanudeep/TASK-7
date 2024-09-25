variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.large"
}

variable "ami" {
  description = "AMI for the EC2 instance"
  default     = "ami-0000791bad666add5"  # Ubuntu AMI
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  default     = "new"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  default     = "medusa-ecr-new"
}

variable "instance_storage" {
  description = "Storage size for the EC2 instance in GB"
  default     = 16
}
