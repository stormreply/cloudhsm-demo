resource "null_resource" "activate_cluster" {
  triggers = {
    name = var.deployment.name
  }
  provisioner "local-exec" {
    command = <<-EOF

    ls -la /opt

    # activate cluster
    /opt/cloudhsm/bin/configure-cli -a "${aws_cloudhsm_v2_hsm.hsm_one.ip_address}"
    /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${random_string.admin_password.id}"

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

    EOF
    quiet   = false
  }
  depends_on = [
    null_resource.initialize_cluster
  ]
}
