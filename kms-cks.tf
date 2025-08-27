resource "aws_kms_custom_key_store" "cloudhsm" {
  cloud_hsm_cluster_id     = aws_cloudhsm_v2_cluster.cluster.cluster_id
  custom_key_store_name    = var.deployment.name
  key_store_password       = random_string.kmsuser.id
  trust_anchor_certificate = data.local_file.customer_ca_crt.content
}
