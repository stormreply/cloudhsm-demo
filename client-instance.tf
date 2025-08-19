
module "cloudhsm_client" {
  # checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  # checkov:skip=CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
  # tflint-ignore: terraform_module_pinned_source
  source           = "git::https://github.com/stormreply/terraform-build-controller.git"
  deployment       = var.deployment
  policies         = [aws_iam_policy.client.arn]
  root_volume_size = 50
  user_data        = local.user_data
  vpc_security_group_ids = [
    aws_security_group.client.name,
    "cloudhsm-${aws_cloudhsm_v2_cluster.cluster.cluster_id}"
  ]
  depends_on = [
    aws_secretsmanager_secret_version.admin_password
  ]
}

locals {
  user_data = <<-EOF
  #!/bin/bash

  # get CloudHSM CLI
  curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-cli-latest.el7.x86_64.rpm
  yum -y install ./cloudhsm-cli-latest.el7.x86_64.rpm

  # NOTE: apparently obsolete
  # get AWS CloudHSM client, containing CloudHSM and Key Management Utility (CMU and KMU)
  # curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-client-latest.el7.x86_64.rpm
  # yum install ./cloudhsm-client-latest.el7.x86_64.rpm

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
  cp customerCA.crt /opt/cloudhsm/etc/customerCA.crt

  # copy customerCA.crt to /home/ec2-user for later download
  cp customerCA.crt /home/ec2-user/customerCA.crt

  # create CustomerHsmCertifica
  openssl x509 \
    -req \
    -days 3652 \
    -in ClusterCsr.csr \
    -CA customerCA.crt \
    -CAkey customerCA.key \
    -CAcreateserial \
    -out CustomerHsmCertificate.crt

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

  # activate cluster
  /opt/cloudhsm/bin/configure-cli -a "${aws_cloudhsm_v2_hsm.hsm_one.ip_address}"
  /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${random_string.admin_password.id}"

  # create kmsuser
  export CLOUDHSM_ROLE=admin
  export CLOUDHSM_PIN="admin:${random_string.admin_password.id}"
  /opt/cloudhsm/bin/cloudhsm-cli user create \
    --username kmsuser \
    --role crypto-user \
    --password "${random_string.kmsuser_password.id}"
  EOF
  tags = {
    Name = "${var.deployment.name}-controller"
  }
}
