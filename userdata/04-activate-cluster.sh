#!/bin/bash -x

echo "BEGIN -- 04-activate-cluster.sh"

# activate cluster
sudo /opt/cloudhsm/bin/configure-cli -a ${ip_address}
sudo /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${password}"

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

echo "END ---- 04-activate-cluster.sh"
