#!/bin/bash -x

echo "BEGIN -- 06-check-active.sh"

cluster_id=$1

while [ "$CLUSTER_STATE" != "ACTIVE" ] ; do
    sleep 10
    CLUSTER_STATE=$(
    aws cloudhsmv2 describe-clusters \
        --filters clusterIds=${cluster_id} \
        --query 'Clusters[].State' \
        --output text
    )
    echo current status: $CLUSTER_STATE
done

echo "END ---- 06-check-active.sh"
