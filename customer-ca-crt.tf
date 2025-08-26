data "local_file" "customer_ca_crt" {
  filename = "/tmp/customerCA.crt"
  depends_on = [
    null_resource.cluster_init
  ]
}
