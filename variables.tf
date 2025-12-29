# AWS Region - Mumbai datacenter for lowest latency
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

# VPC CIDR - Your private network address range
# 10.0.0.0/16 = 65,536 possible IP addresses
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Project name - Used for tagging all resources
variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "aws-vpc-demo"
}

# Public subnet - Where internet-facing resources live
# 10.0.1.0/24 = 256 IP addresses
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# EC2 instance type - t3.micro as alternative to t2.micro
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}