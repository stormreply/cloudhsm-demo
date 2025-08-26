data "cloudinit_config" "controller" {

  # see https://discuss.hashicorp.com/t/terraform-template-cloudinit-config-multiple-part-execution-order-is-wrong/16962/3
  gzip          = false
  base64_encode = true

  part {
    filename     = "01-create-certificates.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/01-create-certificates.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    })
  }

  part {
    filename     = "02-initialize-cluster.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/02-initialize-cluster.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    })
  }

  part {
    filename     = "03-install-cloudhsm-cli.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/scripts/03-install-cloudhsm-cli.sh")
  }

  part {
    filename     = "04-activate-cluster.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/04-activate-cluster.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
      ip_address = aws_cloudhsm_v2_hsm.hsm_one.ip_address
      password   = random_string.password["admin"].id
    })
  }

  part {
    filename     = "05-create-kmsuser.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/05-create-kmsuser.sh", {
      admin_password   = random_string.password["admin"].id
      kmsuser_password = random_string.password["kmsuser"].id
    })
  }
}
