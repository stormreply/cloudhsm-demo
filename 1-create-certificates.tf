resource "null_resource" "create_certificates" {
  triggers = {
    name = var.deployment.name
  }
  provisioner "local-exec" {
    command = <<-EOF

    # get CloudHSM CLI for Ubuntu 24.04
    curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Noble/cloudhsm-cli_latest_u24.04_amd64.deb
    sudo apt install ./cloudhsm-cli_latest_u24.04_amd64.deb

    ls -la /opt

    CLUSTER_ID="${aws_cloudhsm_v2_cluster.cluster.cluster_id}"
    touch ClusterCsr.csr

    # get cluster CSR
    while [ $(cat ClusterCsr.csr | wc -c) -eq 0 ] ; do
      sleep 1
      aws cloudhsmv2 describe-clusters \
        --filters clusterIds=$CLUSTER_ID \
        --query 'Clusters[].Certificates.ClusterCsr' \
        --output text \
      > ClusterCsr.csr
    done

    # create customerCA
    openssl req \
      -x509 \
      -nodes \
      -days 3652 \
      -newkey rsa:4096 \
      -subj "/O=ACME Examples, Inc/CN=example.com" \
      -keyout customerCA.key \
      -out customerCA.crt

    # copy customerCA.crt to config location
    # cp customerCA.crt /opt/cloudhsm/etc/customerCA.crt

    # copy customerCA.crt to /home/ec2-user for later download
    # cp customerCA.crt /home/ec2-user/customerCA.crt

    # create CustomerHsmCertificate
    openssl x509 \
      -req \
      -days 3652 \
      -in ClusterCsr.csr \
      -CA customerCA.crt \
      -CAkey customerCA.key \
      -CAcreateserial \
      -out CustomerHsmCertificate.crt

    EOF
    quiet   = true
  }
  depends_on = [
    aws_cloudhsm_v2_cluster.cluster
  ]
}
