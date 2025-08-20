resource "random_string" "kmsuser_password" {
  length           = 16
  special          = true
  min_lower        = 4
  min_upper        = 4
  override_special = "!@#$%&*()-_=+[]{}<>?" # no ":"
}

resource "aws_secretsmanager_secret" "kmsuser_password" {
  # checkov:skip=CKV2_AWS_57: "No rotation required for now"
  # checkov:skip=CKV_AWS_149: "Encrypt by default AWS kms key"
  name = "${var.deployment.name}-kmsuser-password-${random_string.suffix.result}" # needs suffix for re-creation
}

# Creating a AWS secret versions for database cluster admin account
resource "aws_secretsmanager_secret_version" "kmsuser_password" {
  secret_id     = aws_secretsmanager_secret.kmsuser_password.id
  secret_string = random_string.kmsuser_password.result
}

output "kmsuser_password" {
  value = random_string.kmsuser_password.result
}
