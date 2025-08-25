resource "null_resource" "cluster_init" {

  triggers = {
    name = var.deployment.name
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/01-create-certificates.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/02-initialize-cluster.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }

  depends_on = [aws_cloudhsm_v2_cluster.cluster]
}
