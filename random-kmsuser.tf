resource "random_string" "kmsuser" {
  length    = 16
  special   = true
  min_lower = 4
  min_upper = 4
  override_special = "!@#$%&*()-_=+[]{}<>?"   # no ":"
}