locals {
  module_name = basename(abspath(path.module))
  deployment = merge(
    var.deployment,
    var.deployment.name == "" ? { name = local.module_name } : {},
    var.deployment.short_name == "" ? { short_name = local.module_name } : {}
  )
}

variable "deployment" {
  type = object({
    actor       = string # Github actor (deployer) of the deployment
    environment = string # environment of the deployment
    name        = string # name of the deployment
    ref         = string # Git reference of the deployment
    ref_name    = string # Git ref_name (branch) of the deployment
    repo        = string # GitHub short repository name (without owner) of the deployment
    repository  = string # GitHub full repository name (including owner) of the deployment
    sha         = string # Git (full-length, 40 char) commit SHA of the deployment
    short_name  = string # Short name of the deployment
    time        = string # Timestamp of the deployment
  })
  default = {
    actor       = ""
    environment = ""
    name        = ""
    ref         = ""
    ref_name    = ""
    repo        = ""
    repository  = ""
    sha         = ""
    short_name  = ""
    time        = ""
  }
}

output "deployment" {
  value = var.deployment
}
