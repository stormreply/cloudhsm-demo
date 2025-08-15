output "admin_password" {
  value = random_string.admin.id
}

output "kmsuser_password" {
  value = random_string.kmsuser.id
}