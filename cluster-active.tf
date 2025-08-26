resource "null_resource" "cluster_active" {

  triggers = {
    name = var.deployment.name
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/06-check-active.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }

  depends_on = [
    aws_cloudhsm_v2_cluster.cluster
  ]
}
