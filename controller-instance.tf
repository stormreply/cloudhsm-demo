locals {
  controller_metadata = merge(
    local._metadata,
    {
      name = "${local._deployment}-controller"
    }
  )
}
module "controller" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source           = "git::https://github.com/stormreply/terraform-build-controller.git"
  deployment       = local.controller_metadata
  key_name         = aws_key_pair.controller.key_name
  policies         = [aws_iam_policy.controller.arn]
  root_volume_size = 50
  user_data_base64 = base64encode(trimspace(data.cloudinit_config.controller.rendered))
  vpc_security_group_ids = [
    aws_security_group.controller.id,
    aws_cloudhsm_v2_cluster.cluster.security_group_id
  ]
}
