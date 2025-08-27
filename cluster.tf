resource "aws_cloudhsm_v2_cluster" "cluster" {
  hsm_type   = "hsm2m.medium" # only option atm, do not change
  mode       = "FIPS"
  subnet_ids = [local.default_subnets["a"], local.default_subnets["b"]]
}
