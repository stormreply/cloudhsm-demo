module "controller" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source           = "git::https://github.com/stormreply/terraform-build-controller.git"
  deployment       = var.deployment
  policies         = [aws_iam_policy.client.arn]
  root_volume_size = 50
  user_data        = data.cloudinit_config.controller.rendered
  vpc_security_group_ids = [
    aws_security_group.client.id,
    "cloudhsm-${aws_cloudhsm_v2_cluster.cluster.cluster_id}-sg"
  ]
  depends_on = [
    null_resource.cluster_init,
    aws_cloudhsm_v2_hsm.hsm_one,
    random_string.password["admin"],
    random_string.password["kmsuser"]
  ]
}

# TODO: what about sg cloudhsm-${aws_cloudhsm_v2_cluster.cluster.cluster_id?
