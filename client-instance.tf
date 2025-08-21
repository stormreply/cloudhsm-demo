
module "cloudhsm_client" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source           = "git::https://github.com/stormreply/terraform-build-controller.git"
  deployment       = var.deployment
  policies         = [aws_iam_policy.client.arn]
  root_volume_size = 50
  user_data        = <<-EOF
    #!/bin/bash
    curl -O  https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Amzn2023/cloudhsm-cli-latest.amzn2023.x86_64.rpm
    sudo yum install ./cloudhsm-cli-latest.amzn2023.x86_64.rpm
  EOF
  vpc_security_group_ids = [
    aws_security_group.client.name,
  ]
}

# TODO: what about sg cloudhsm-${aws_cloudhsm_v2_cluster.cluster.cluster_id?
