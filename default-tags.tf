locals {
  default_tags = merge(
    {
      for key, value in var.deployment : "deployment-${replace(key, "_", "-")}" => value if value != ""
    },
    var.deployment.ref_name == ""
    ? {}
    : { deployment-code = "https://github.com/${var.deployment.repository}/tree/${var.deployment.ref_name}" },
    var.deployment.sha == ""
    ? {}
    : { deployment-commit = "https://github.com/${var.deployment.repository}/commit/${var.deployment.sha}" },
    var.deployment.repository == ""
    ? {}
    : { deployment-repository = var.deployment.repository == "" ? "" : "https://github.com/${var.deployment.repository}" },
    var.deployment.sha == ""
    ? {}
    : { deployment-sha = var.deployment.repository == "" ? "" : substr(var.deployment.sha, 0, 7) },
  )
}
