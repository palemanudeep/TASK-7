output "ec2_public_ip" {
  value = aws_instance.medusa_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.medusa_repository.repository_url
}
