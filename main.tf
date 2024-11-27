provider "aws" {
  region = var.region  # Uses the region defined in the tfvars file
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  vpc_id      = aws_vpc.main.id

  ingress {
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

resource "aws_instance" "public_vm" {
  ami                = var.ami_id  # Reference the ami_id variable
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  key_name           = var.key_name  # Reference the key_name variable
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
            EOF

  tags = {
    Name = "Public-VM"
  }
}

resource "aws_instance" "private_vm" {
  ami                = var.ami_id  # Reference the ami_id variable
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.private.id
  key_name           = var.key_name  # Reference the key_name variable
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
            EOF

  tags = {
    Name = "Private-VM"
  }
}

resource "aws_key_pair" "default" {
  key_name   = var.key_name  # Reference the key_name variable
  public_key = tls_private_key.default.public_key_openssh
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "private_key" {
  value     = tls_private_key.default.private_key_pem
  sensitive = true
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block  # Reference the VPC CIDR block variable
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr  # Reference the public subnet CIDR block variable
  availability_zone       = var.availability_zone  # Reference the availability zone variable
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr  # Reference the private subnet CIDR block variable
  availability_zone       = var.availability_zone  # Reference the availability zone variable
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
