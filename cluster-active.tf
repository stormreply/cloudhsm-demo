resource "null_resource" "cluster_active" {

  triggers = {
    name = var.deployment.name
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/06-check-active.sh $cluster_id"
    environment = {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
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
    aws_cloudhsm_v2_cluster.cluster
  ]
}
