#!/bin/bash

# get CloudHSM CLI for Ubuntu 24.04
curl -O https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Noble/cloudhsm-cli_latest_u24.04_amd64.deb
apt install ./cloudhsm-cli_latest_u24.04_amd64.deb

CLUSTER_ID=$1 IP_ADDRESS=$2 PASSWORD_ID=$3

# activate cluster
/opt/cloudhsm/bin/configure-cli -a $IP_ADDRESS
/opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "$PASSWORD_ID"

ls -la /opt/cloudhsm/
ls -la /opt/cloudhsm/etc
ls -la /opt/cloudhsm/etc/cloudhsm-cli.cfg
cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "activating - can take up to 4mins"
while [ "$CLUSTER_STATE" != "ACTIVE" ] ; do
    sleep 5
    CLUSTER_STATE=$(
    aws cloudhsmv2 describe-clusters \
        --filters clusterIds=$CLUSTER_ID \
        --query 'Clusters[].State' \
        --output text
    )
    echo current status: $CLUSTER_STATE
done
