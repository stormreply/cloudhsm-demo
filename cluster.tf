resource "aws_cloudhsm_v2_cluster" "cluster" {
  hsm_type   = "hsm2m.medium" # only option atm, do not change
  mode       = "FIPS"
  subnet_ids = [local.default_subnets["a"], local.default_subnets["b"]]
}

# Log Group Cleanup bei Destroy
resource "null_resource" "delete_cloudhsm_log_group" {
  depends_on = [aws_cloudhsm_v2_cluster.cluster]

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      aws logs delete-log-group \
        --log-group-name /aws/cloudhsm/${self.triggers.cluster_id} \
      || true
    EOT
  }

  triggers = {
    cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
  }
}
