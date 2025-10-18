resource "null_resource" "poll_cluster_state" {

  triggers = {
    name = local._deployment
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/06-poll-cluster-state.sh $cluster_id"
    environment = {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }

  depends_on = [aws_cloudhsm_v2_hsm.hsm_one]
}
