resource "random_string" "admin_password" {
  length           = 16
  special          = true
  min_lower        = 4
  min_upper        = 4
  override_special = "!@#$%&*()-_=+[]{}<>?" # no ":"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
}

resource "aws_secretsmanager_secret" "admin_password" {
  # checkov:skip=CKV2_AWS_57: "No rotation required for now"
  # checkov:skip=CKV_AWS_149: "Encrypt by default AWS kms key"
  name = "${var.deployment.name}-admin-password-${random_string.suffix.result}" # needs suffix for re-creation
}

# Creating a AWS secret versions for database cluster admin account
resource "aws_secretsmanager_secret_version" "admin_password" {
  secret_id     = aws_secretsmanager_secret.admin_password.id
  secret_string = random_password.admin_password.result
}

output "admin_password" {
  value = random_password.admin_password.result
}
