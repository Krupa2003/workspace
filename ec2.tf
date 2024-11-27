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
  ami                = "ami-001eed247d2135475"  # Replace with the latest Amazon Linux 2 AMI
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.public.id
  key_name           = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]  # Use vpc_security_group_ids for custom security groups

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
  ami                = "ami-001eed247d2135475"  # Replace with the latest Amazon Linux 2 AMI
  instance_type      = "t2.micro"
  subnet_id          = aws_subnet.private.id
  key_name           = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]  # Use vpc_security_group_ids for custom security groups

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
