resource "null_resource" "poll_cluster_state" {

  triggers = {
    name = var.deployment.name
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/06-poll-cluster-state.sh $cluster_id"
    environment = {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }

  depends_on = [
    aws_cloudhsm_v2_hsm.hsm_two,
    null_resource.poll_cluster_state
  ]
}
