resource "aws_security_group" "application" {
  name        = "l00205530-application-sg"
  description = "Security group managed by the L00205530 policy framework"

  ingress {
    description = "Restricted SSH administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    description = "HTTPS outbound traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "L00205530-Application-SG"
    Organisation = "L00205530"
    Environment  = var.environment
  }
}

resource "aws_instance" "application" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.application.id]
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.imds_http_tokens
  }

  root_block_device {
    encrypted = var.ebs_encrypted
  }

  tags = {
    Name         = "L00205530-Application"
    Organisation = "L00205530"
    Environment  = var.environment
    ManagedBy    = "Terraform"
  }
}
