# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
 locals {
     aws_key = "My_AWS_key"   # SSH key pair name for EC2 instance access
}

# Configure the S3 backend for storing the Terraform state
terraform {
  backend "s3" {
    bucket         = "my-activity-swen-614"
    key            = "tfstate-folder/terraform.tfstate"
    region         = "us-east-1"
    encrypt = false
  }
}
# Security group to allow HTTP, HTTPS, and SSH traffic
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-security-group"
  description = "Allow HTTP, HTTPS, and SSH traffic"

  # Allow SSH access from anywhere (for demonstration purposes; restrict in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-security-group"
  }
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   vpc_security_group_ids = [aws_security_group.wordpress_sg.id]  # Attach the security group
   user_data = filebase64("wp_install.sh")
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
