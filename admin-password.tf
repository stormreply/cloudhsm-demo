resource "random_string" "admin_password" {
  length           = 16
  special          = true
  min_lower        = 4
  min_upper        = 4
  override_special = "!@#$%&*()-_=+[]{}<>?" # no ":"
}

# trivy:ignore:AVD-AWS-0098 (LOW): Secret explicitly uses the default key.
resource "aws_secretsmanager_secret" "admin_password" {
  # checkov:skip=CKV_AWS_149: "Encrypt by default AWS kms key"
  # checkov:skip=CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled"
  name = "${var.deployment.name}-admin-password-${random_string.suffix.result}" # needs suffix for re-creation
}

# Creating a AWS secret versions for database cluster admin account
resource "aws_secretsmanager_secret_version" "admin_password" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = random_string.admin_password.result
}

output "admin_password" {
  value = random_string.admin_password.result
}
