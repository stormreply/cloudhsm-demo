data "local_file" "customer_ca_crt" {
  filename = "customerCA.crt"
  depends_on = [
    null_resource.cluster_active
  ]
}

output "customer_ca_crt" {
  value = data.local_file.customer_ca_crt.content
}
