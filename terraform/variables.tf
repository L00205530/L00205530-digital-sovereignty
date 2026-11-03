variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "eu-west-1"
}

variable "ami_id" {
  description = "AMI identifier used for the EC2 demonstration"
  type        = string
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ebs_encrypted" {
  description = "Whether the EC2 root EBS volume is encrypted"
  type        = bool
  default     = true
}

variable "imds_http_tokens" {
  description = "EC2 metadata service token requirement"
  type        = string
  default     = "required"
}

variable "ssh_ingress_cidr" {
  description = "Approved source CIDR for SSH access"
  type        = string
  default     = "203.0.113.10/32"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "assignment"
}
