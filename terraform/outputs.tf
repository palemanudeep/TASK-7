output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.medusa_repo.repository_url
}
