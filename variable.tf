# Variable definition for EC2 instance type
variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"  # Default to t2.micro if no value is provided
}

variable "aws_key" {
  type = string
  description = "AWS Key Pair Name"
}

variable "aws_access_key"{
  type = string
  description = "AWS Access Key"
  
}

variable "aws_secret_key" {
  type = string
  description = "AWS Secret Key"
}
