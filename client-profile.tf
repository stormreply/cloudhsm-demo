
data "aws_iam_policy_document" "client" {
  # checkov:skip=CKV2_AWS_40: "Ensure AWS IAM policy does not allow full IAM privileges"
  # checkov:skip=CKV_AWS_49: "Ensure no IAM policies documents allow "*" as a statement's actions"
  # checkov:skip=CKV_AWS_107: "Ensure IAM policies does not allow credentials exposure"
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
      "arn:aws:cloudhsm:${local.region}:${local.account_id}:cluster/${aws_cloudhsm_v2_cluster.cluster.cluster_id}"
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

resource "aws_iam_policy" "client" {
  name        = "${var.deployment.name}-client"
  path        = "/"
  description = "Policy for the ${var.deployment.name} client"
  policy      = data.aws_iam_policy_document.client.json
}
