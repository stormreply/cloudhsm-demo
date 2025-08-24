resource "null_resource" "activate_cluster" {
  triggers = {
    name = var.deployment.name
  }
  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./3-activate-cluster.sh $CLUSTER_ID $IP_ADDRESS \"$PASSWORD_ID\""
    environment = {
      CLUSTER_ID  = aws_cloudhsm_v2_cluster.cluster.cluster_id
      IP_ADDRESS  = aws_cloudhsm_v2_hsm.hsm_one.ip_address
      PASSWORD_ID = random_string.admin_password.id
    }
  }
}
