resource "aws_cloudhsm_v2_hsm" "hsm_two" {
  availability_zone = local.azs[1]
  cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
  depends_on = [
    null_resource.pending_cluster_activation
  ]
}
