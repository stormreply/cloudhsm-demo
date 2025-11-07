
#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

cluster_id=$1

slept=0

while [ "$CLUSTER_STATE" != "ACTIVE" -a $slept -lt $((30 * 60)) ] ; do
    sleep 10
    CLUSTER_STATE=$(
    aws cloudhsmv2 describe-clusters \
        --filters clusterIds=${cluster_id} \
        --query 'Clusters[].State' \
        --output text
    )
    echo current status: $CLUSTER_STATE
    slept=$((slept + 10))
done

if [ "$CLUSTER_STATE" != "ACTIVE" ] ; then
    echo "cluster $cluster_id did not reach ACTIVE state. exiting."
    exit 1
fi

echo "END ---- $(basename $0)"
