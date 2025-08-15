
data "aws_iam_policy_document" "client" {
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
