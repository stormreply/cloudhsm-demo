#!/bin/bash

echo "BEGIN -- 02-initialize-cluster.sh"

# cluster_id=$1

# initialize cluster
aws cloudhsmv2 initialize-cluster \
    --cluster-id ${cluster_id} \
    --signed-cert file://CustomerHsmCertificate.crt \
    --trust-anchor file://customerCA.crt

# wait for initialization
while [ "$CLUSTER_STATE" != "INITIALIZED" ] ; do
    sleep 1
    CLUSTER_STATE=$(
    aws cloudhsmv2 describe-clusters \
        --filters clusterIds=${cluster_id} \
        --query 'Clusters[].State' \
        --output text
    )
done

echo "END ---- 02-initialize-cluster.sh"
