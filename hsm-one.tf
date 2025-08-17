resource "aws_cloudhsm_v2_hsm" "hsm_one" {
  availability_zone = local.azs["a"]
  cluster_id        = aws_cloudhsm_v2_cluster.cluster.cluster_id
}
