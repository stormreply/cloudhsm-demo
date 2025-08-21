resource "null_resource" "initialize_cluster" {
  provisioner "local-exec" {
    command = <<-EOF

    CLUSTER_ID="${aws_cloudhsm_v2_cluster.cluster.cluster_id}"

    # initialize cluster
    aws cloudhsmv2 initialize-cluster \
      --cluster-id $CLUSTER_ID \
      --signed-cert file://CustomerHsmCertificate.crt \
      --trust-anchor file://customerCA.crt

    # wait for initialization
    while [ "$CLUSTER_STATE" != "INITIALIZED" ] ; do
      sleep 1
      CLUSTER_STATE=$(
        aws cloudhsmv2 describe-clusters \
          --filters clusterIds=$CLUSTER_ID \
          --query 'Clusters[].State' \
          --output text
      )
    done

    EOF
    quiet   = true
  }
  depends_on = [
    null_resource.create_certificates
  ]
}
