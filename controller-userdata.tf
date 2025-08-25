data "cloudinit_config" "controller" {

  # see https://discuss.hashicorp.com/t/terraform-template-cloudinit-config-multiple-part-execution-order-is-wrong/16962/3
  gzip          = false
  base64_encode = false

  part {
    filename     = "01-install-cloudhsm-cli.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/userdata/01-install-cloudhsm-cli.sh")
  }

  part {
    filename     = "02-create-certificates.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/02-create-certificates.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    })
  }

  part {
    filename     = "03-initialize-cluster.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/03-initialize-cluster.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
    })
  }

  part {
    filename     = "04-activate-cluster.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/04-activate-cluster.sh", {
      cluster_id = aws_cloudhsm_v2_cluster.cluster.cluster_id
      ip_address = aws_cloudhsm_v2_hsm.hsm_one.ip_address
      password   = random_string.admin_password.id
    })
  }

  part {
    filename     = "05-create-kmsuser.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/05-create-kmsuser.sh", {
      admin_password   = random_string.admin_password.id
      kmsuser_password = random_string.kmsuser_password.id
    })
  }
}
