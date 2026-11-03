output "aws_region" {
  description = "Configured AWS deployment region"
  value       = var.aws_region
}

output "ec2_instance_type" {
  description = "Configured EC2 instance type"
  value       = aws_instance.application.instance_type
}

output "ebs_encryption_enabled" {
  description = "Root EBS encryption configuration"
  value       = aws_instance.application.root_block_device[0].encrypted
}

output "imds_http_tokens" {
  description = "EC2 metadata token configuration"
  value       = aws_instance.application.metadata_options[0].http_tokens
}

output "security_group_id" {
  description = "Application security group identifier"
  value       = aws_security_group.application.id
}
