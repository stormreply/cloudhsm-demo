resource "null_resource" "pending_cluster_activation" {
  provisioner "local-exec" {
    command = <<-EOF
    echo "activating - can take up to 4mins"
    while [ "$CLUSTER_STATE" != "ACTIVE" ] ; do
      sleep 5
      CLUSTER_STATE=$(
        aws cloudhsmv2 describe-clusters \
          --filters clusterIds=${aws_cloudhsm_v2_cluster.cluster.cluster_id} \
          --query 'Clusters[].State' \
          --output text
      )
      echo current status: $CLUSTER_STATE
    done
    scp \
      -i ${var.private_key_file} \
      -o StrictHostKeyChecking=no \
      ec2-user@${aws_instance.cloudhsm_client.public_ip}:/customerCA.crt ./customerCA.crt
    EOF
    quiet   = true
  }
  depends_on = [
    aws_instance.cloudhsm_client
  ]
}
