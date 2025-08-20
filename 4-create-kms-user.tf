resource "null_resource" "create_kms_user" {
  provisioner "local-exec" {
    command = <<-EOF

    # create kmsuser
    export CLOUDHSM_ROLE=admin
    export CLOUDHSM_PIN="admin:${random_string.admin_password.id}"
    /opt/cloudhsm/bin/cloudhsm-cli user create \
      --username kmsuser \
      --role crypto-user \
      --password "${random_string.kmsuser_password.id}"

    EOF
    quiet   = true
  }
  depends_on = [
    null_resource.activate_cluster
  ]
}
