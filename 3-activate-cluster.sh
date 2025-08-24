#!/bin/bash

CLUSTER_ID=$1 IP_ADDRESS=$2 PASSWORD_ID=$3

# activate cluster
/opt/cloudhsm/bin/configure-cli -a $IP_ADDRESS
/opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "$PASSWORD_ID"

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
