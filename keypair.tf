provider "aws" {
  region = "eu-central-1"
}

resource "tls_private_key" "secure" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "secure" {
  key_name   = var.deployment.name
  public_key = tls_private_key.secure.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.secure.private_key_pem
  filename        = "${path.module}/${var.deployment.name}.pem"
  file_permission = "0600"
}

output "key_pair_name" {
  value = aws_key_pair.secure.key_name
}
