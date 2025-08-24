resource "aws_cloudhsm_v2_cluster" "cluster" {
  hsm_type   = "hsm2m.medium" # only option atm, do not change
  mode       = "NON_FIPS"
  subnet_ids = [local.default_subnets["a"], local.default_subnets["b"]]

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./1-create-certificates.sh ${self.cluster_id}"
  }

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./2-initialize-cluster.sh ${self.cluster_id}"
  }
}
