resource "aws_key_pair" "default" {
  key_name   = "terraform-key"
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
