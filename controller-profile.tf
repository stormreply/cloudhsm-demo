
data "aws_iam_policy_document" "controller" {
  # checkov:skip=CKV_AWS_1: "Ensure IAM policies that allow full "*-*" administrative privileges are not created"
  # checkov:skip=CKV_AWS_49: "Ensure no IAM policies documents allow "*" as a statement's actions"
  # checkov:skip=CKV_AWS_107: "Ensure IAM policies does not allow credentials exposure"
  # checkov:skip=CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
  # checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  # checkov:skip=CKV_AWS_110: "Ensure IAM policies does not allow privilege escalation"
  # checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  # checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  # checkov:skip=CKV2_AWS_40: "Ensure AWS IAM policy does not allow full IAM privileges"
  statement {
    sid    = "AllowDescribeClusters"
    effect = "Allow"
    actions = [
      "cloudhsm:DescribeClusters"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowAllInCluster"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "*"
      # "arn:aws:cloudhsm:${local.region}:${local.account_id}:cluster/${aws_cloudhsm_v2_cluster.cluster.cluster_id}"
    ]
  }
  statement {
    sid    = "AllowAllOnBackups"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "arn:aws:cloudhsm:${local.region}:${local.account_id}:backup/*" # TODO: reconsider
    ]
  }
}

resource "aws_iam_policy" "controller" {
  name        = "${local._deployment}-controller"
  path        = "/"
  description = "Policy for the ${local._deployment} controller"
  policy      = data.aws_iam_policy_document.controller.json
}
