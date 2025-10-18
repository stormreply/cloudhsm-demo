resource "aws_kms_custom_key_store" "cloudhsm" {
  cloud_hsm_cluster_id     = aws_cloudhsm_v2_cluster.cluster.cluster_id
  custom_key_store_name    = local._deployment
  key_store_password       = random_string.password["kmsuser"].result
  trust_anchor_certificate = data.local_file.customer_ca_crt.content

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/wait-keystore-connected.sh $keystore_id"
    environment = {
      keystore_id = self.id
    }
  }

  provisioner "local-exec" {
    when    = destroy
    quiet   = false
    command = "bash ./local-exec/wait-keystore-disconnected.sh $keystore_id"
    environment = {
      keystore_id = self.id
    }
  }
}
