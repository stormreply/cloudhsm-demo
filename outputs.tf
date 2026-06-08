output "_summary" {
  description = "Key-value pairs to be published in the GITHUB_STEP_SUMMARY"

  value = {
    "Admin Password"    = random_string.password["admin"].result
    "KMS User Password" = random_string.password["kmsuser"].result
  }
}
