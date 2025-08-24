resource "null_resource" "initialize_cluster" {
  triggers = {
    name = var.deployment.name
  }
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./2-initialize-cluster.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = aws_cloudhsm_v2_cluster.cluster.cluster_id
    }
  }
  depends_on = [null_resource.create_certificates]
}
