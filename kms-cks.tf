resource "aws_kms_custom_key_store" "cloudhsm" {
  cloud_hsm_cluster_id     = aws_cloudhsm_v2_cluster.cluster.cluster_id
  custom_key_store_name    = "${var.deployment.name}-cloudhsm-keystore"
  key_store_password       = random_string.kmsuser_password.id
  trust_anchor_certificate = data.local_file.customer_ca_crt.content
  depends_on = [
    aws_cloudhsm_v2_hsm.hsm_two
  ]
}
