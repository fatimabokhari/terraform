# Provider block - specify AWS provider details
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# VPC resource
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ExampleVPC"
  }
}

# Subnet resource
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "ExampleSubnet"
  }
}

# Internet Gateway resource
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "ExampleIGW"
  }
}

# Route Table resource
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExampleRouteTable"
  }
}

# Route Table Association resource
resource "aws_route_table_association" "example_route_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Security Group resource
resource "aws_security_group" "example_security_group" {
  name   = "ExampleSecurityGroup"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

# EC2 Instance resource
resource "aws_instance" "example_instance" {
  ami           = "ami-04a81a99f5ec58529"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  key_name      = "MyKeyPair"  # Replace with your SSH key pair name

  vpc_security_group_ids = [aws_security_group.example_security_group.id]

  tags = {
    Name = "ExampleInstance"
  }
}
