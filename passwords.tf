locals {
  hsm_users = toset(["admin", "kmsuser"])
}

resource "random_string" "password" {
  for_each         = local.hsm_users
  length           = 16
  special          = true
  min_lower        = 4
  min_upper        = 4
  override_special = "!@#$%&*()-_=+[]{}<>?" # no ":"
}

# trivy:ignore:AVD-AWS-0098 (LOW): Secret explicitly uses the default key.
resource "aws_secretsmanager_secret" "password" {
  # checkov:skip=CKV_AWS_149: "Encrypt by default AWS kms key"
  # checkov:skip=CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled"
  for_each = local.hsm_users
  name     = "${var.deployment.name}-${each.key}-TO-BE-DELETED-${random_string.suffix.result}" # needs suffix for re-creation
}

# Creating a AWS secret versions for database cluster admin account
resource "aws_secretsmanager_secret_version" "password" {
  for_each      = local.hsm_users
  secret_id     = aws_secretsmanager_secret.password[each.key].id
  secret_string = random_string.password[each.key].result
}

output "admin_pw" {
  value = random_string.password["admin"].result
}

output "kmsuser_pw" {
  value = random_string.password["kmsuser"].result
}
