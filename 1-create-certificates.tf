resource "null_resource" "create_certificates" {
  triggers = {
    name = var.deployment.name
  }
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./1-create-certificates.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }
  depends_on = [aws_cloudhsm_v2_cluster.cluster]
}
