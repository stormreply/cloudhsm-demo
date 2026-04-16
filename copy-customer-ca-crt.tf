resource "null_resource" "copy_customer_ca_crt" {
  triggers = {
    name = local._deployment
  }
  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./local-exec/copy-customer-ca-crt.sh $instance_id"
    environment = {
      instance_id = module.controller.instance.id
    }
  }
  depends_on = [
    aws_cloudhsm_v2_hsm.hsm_two,
    null_resource.wait_cluster_active
  ]
}
