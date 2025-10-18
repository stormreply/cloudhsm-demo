resource "null_resource" "wait_cluster_active" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./local-exec/wait-cluster-active.sh $cluster_id"
    environment = {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }
}
