data "local_file" "customer_ca_crt" {
  filename = "customerCA.crt"
  depends_on = [
    null_resource.cluster_init
  ]
}
