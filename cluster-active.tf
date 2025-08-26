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
}
