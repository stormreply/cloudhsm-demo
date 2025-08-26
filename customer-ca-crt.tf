resource "null_resource" "cluster_ca_cert" {

  triggers = {
    name = var.deployment.name
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/07-copy-customer-ca-crt.sh $instance_id"
    environment = {
      instance_id = module.controller.instance.id
    }
  }

  depends_on = [
    null_resource.cluster_active
  ]
}

data "local_file" "customer_ca_crt" {
  filename = "customerCA.crt"
  depends_on = [
    null_resource.cluster_ca_cert
  ]
}

output "customer_ca_crt" {
  value = data.local_file.customer_ca_crt.content
}
