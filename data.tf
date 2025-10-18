data "local_file" "customer_ca_crt" {
  filename = "customer-ca.crt"
  depends_on = [
    null_resource.copy_customer_ca_cert
  ]
}

# output "customer_ca_crt" {
#   value = data.local_file.customer_ca_crt.content
# }
