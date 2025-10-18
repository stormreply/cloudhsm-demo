
#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

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

echo "END ---- $(basename $0)"
