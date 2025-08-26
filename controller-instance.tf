module "controller" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source           = "git::https://github.com/stormreply/terraform-build-controller.git"
  deployment       = var.deployment
  policies         = [aws_iam_policy.client.arn]
  root_volume_size = 50
  user_data_base64 = base64encode(trimspace(data.cloudinit_config.example.rendered))
  vpc_security_group_ids = [
    aws_security_group.client.id,
    "cloudhsm-${aws_cloudhsm_v2_cluster.cluster.cluster_id}-sg"
  ]
}
