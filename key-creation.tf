resource "null_resource" "certificate_creation" {
  triggers = {
    upload_bucket = var.deployment.name
  }
  provisioner "local-exec" {
    command = <<-EOF
      # set +e

      # get CloudHSM CLI
      curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-cli-latest.el7.x86_64.rpm
      yum -y install ./cloudhsm-cli-latest.el7.x86_64.rpm

      # NOTE: apparently obsolete
      # get AWS CloudHSM client, containing CloudHSM and Key Management Utility (CMU and KMU)
      # curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-client-latest.el7.x86_64.rpm
      # yum install ./cloudhsm-client-latest.el7.x86_64.rpm

      CLUSTER_ID="${aws_cloudhsm_v2_cluster.cluster.cluster_id}"
      touch cluster.csr

      # get cluster CSR
      while [ $(cat cluster.csr | wc -c) -eq 0 ] ; do
        sleep 1
        aws cloudhsmv2 describe-clusters \
          --filters clusterIds=$CLUSTER_ID \
          --query 'Clusters[].Certificates.cluster' \
          --output text \
        > cluster.csr
      done

      # create customer_ca
      openssl req \
        -x509 \
        -nodes \
        -days 3652 \
        -newkey rsa:4096 \
        -subj "/O=ACME Examples, Inc/CN=example.com" \
        -keyout customer_ca.key \
        -out customer_ca.crt

      # copy customer_ca.crt to config location
      cp customer_ca.crt /opt/cloudhsm/etc/customer_ca.crt

      # copy customer_ca.crt to /home/ec2-user for later download
      cp customer_ca.crt /home/ec2-user/customer_ca.crt

      # create CustomerHsmCertifica
      openssl x509 \
        -req \
        -days 3652 \
        -in cluster.csr \
        -CA customer_ca.crt \
        -CAkey customer_ca.key \
        -CAcreateserial \
        -out customer.crt
    EOF
    when    = create
  }
  # provisioner "local-exec" {
  #   command = <<-EOF
  #     # set +e

  #   EOF
  #   when    = destroy
  # }
  depends_on = [
    aws_cloudhsm_v2_cluster.cluster
  ]
}
