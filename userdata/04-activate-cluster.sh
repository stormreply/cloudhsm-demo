#!/bin/bash -x

cat << EOF
{
  "ClusterId": "${cluster_id}",
  "HsmIp": "${ip_address}",
  "HsmPassword": "${password}"
}
EOF

# activate cluster
sudo /opt/cloudhsm/bin/configure-cli -a ${ip_address}
sudo /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${password}"

ls -la /opt/cloudhsm/
ls -la /opt/cloudhsm/etc
ls -la /opt/cloudhsm/etc/cloudhsm-cli.cfg
cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "activating - can take up to 4mins"
while [ "$CLUSTER_STATE" != "ACTIVE" ] ; do
    sleep 5
    CLUSTER_STATE=$(
    aws cloudhsmv2 describe-clusters \
        --filters clusterIds=${cluster_id} \
        --query 'Clusters[].State' \
        --output text
    )
    echo current status: $CLUSTER_STATE
done
