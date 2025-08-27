data "local_file" "customer_ca_crt" {
  filename = "customerCA.crt"
  depends_on = [
    null_resource.cluster_ca_cert
  ]
}

output "customer_ca_crt" {
  value = data.local_file.customer_ca_crt.content
}
