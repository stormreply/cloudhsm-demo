resource "aws_cloudhsm_v2_cluster" "cluster" {
  hsm_type   = "hsm1.medium"   # only option atm, do not change
  subnet_ids = [local.default_subnets[0], local.default_subnets[1]]
}

data "aws_cloudhsm_v2_cluster" "cluster" {
  # by using the data source, both cluster and hsm can start deploying at the same time
  cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
  depends_on = [aws_cloudhsm_v2_hsm.hsm_one]
}
