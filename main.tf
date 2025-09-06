terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-2"
}

# ------------------------------
# VPC
# ------------------------------
resource "aws_vpc" "flockflow_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "flockflow-vpc"
  }
}

# ------------------------------
# Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.flockflow_vpc.id

  tags = {
    Name = "flockflow-igw"
  }
}

# ------------------------------
# Public Subnet
# ------------------------------
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.flockflow_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.flockflow_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["us-east-2a", "us-east-2b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "flockflow-public-${count.index}"
  }
}

# ------------------------------
# Private Subnet
# ------------------------------
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.flockflow_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.flockflow_vpc.cidr_block, 8, count.index + 10)
  availability_zone = element(["us-east-2a", "us-east-2b"], count.index)

  tags = {
    Name = "flockflow-private-${count.index}"
  }
}

# ------------------------------
# Route Tables
# ------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.flockflow_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "flockflow-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ------------------------------
# S3 Bucket
# ------------------------------
resource "aws_s3_bucket" "frontend" {
  bucket = "flockflow-frontend"
  tags = {
    Name = "flockflow-frontend"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}




