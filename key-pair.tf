resource "tls_private_key" "controller" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "controller" {
  key_name   = var.deployment.name
  public_key = tls_private_key.controller.public_key_openssh
}

# optional: privaten Schlüssel lokal abspeichern
resource "local_file" "private_key" {
  content  = tls_private_key.controller.private_key_pem
  filename = "${path.module}/controller.pem"
}

resource "null_resource" "private_key_chmod" {
  depends_on = [local_file.private_key]

  provisioner "local-exec" {
    # command = "chmod 600 ${local_file.private_key.filename}"
    command = <<-EOF
      chmod 600 ${local_file.private_key.filename}
      pwd
      echo ${local_file.private_key.filename}
      ls -la ${local_file.private_key.filename}
    EOF
  }
}
