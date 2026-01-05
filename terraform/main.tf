terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  # When using tflocal with LocalStack, the endpoint is typically injected
  # by the tflocal wrapper, but we keep this here as a fallback.
  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "managed_bucket" {
  bucket = "vigilant-managed-bucket"
}

resource "aws_security_group" "web_sg" {
  name        = "vigilant-web-sg"
  description = "Allow HTTP traffic"
  vpc_id      = "vpc-12345678" # Dummy VPC ID for LocalStack

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "app_server" {
  ami                    = "ami-12345678" # Dummy AMI ID for LocalStack
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "vigilant-app-server"
  }
}


