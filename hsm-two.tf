resource "aws_cloudhsm_v2_hsm" "hsm_two" {
  availability_zone = local.azs.names[1]
  cluster_id        = aws_cloudhsm_v2_cluster.cluster.cluster_id
}
