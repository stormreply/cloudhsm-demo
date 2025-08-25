resource "aws_cloudhsm_v2_cluster" "cluster" {
  hsm_type   = "hsm2m.medium" # only option atm, do not change
  mode       = "NON_FIPS"
  subnet_ids = [local.default_subnets["a"], local.default_subnets["b"]]

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./scripts/01-create-certificates.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = self.cluster_id
    }
  }

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    quiet      = false
    command    = "bash ./scripts/02-initialize-cluster.sh $CLUSTER_ID"
    environment = {
      CLUSTER_ID = self.cluster_id
    }
  }

}
