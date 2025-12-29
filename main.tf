# Terraform configuration - specifies required version and providers
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider - connects Terraform to your AWS account
provider "aws" {
  region = var.aws_region
}

# VPC - Your isolated virtual network in AWS
# Like your own private data center in the cloud
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true  # Allows EC2 instances to get DNS names
  enable_dns_support   = true  # Enables DNS resolution

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# Internet Gateway - The door to the internet for your VPC
# Without this, your VPC is completely isolated
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# Public Subnet - Internet-accessible subnet for web servers
# Resources here get public IPs and can be reached from internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"  # ap-south-1a
  map_public_ip_on_launch = true  # Auto-assign public IPs

  tags = {
    Name    = "${var.project_name}-public-subnet"
    Project = var.project_name
    Type    = "Public"
  }
}

# Public Route Table - Routes internet traffic through Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  # All internet traffic
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}