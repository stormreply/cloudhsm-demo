resource "null_resource" "copy_customer_ca_cert" {
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
    aws_cloudhsm_v2_hsm.hsm_two,
    null_resource.poll_cluster_state
  ]
}
