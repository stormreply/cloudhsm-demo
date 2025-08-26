#!/bin/bash -x

echo "BEGIN -- 04-activate-cluster.sh"

# activate cluster
sudo /opt/cloudhsm/bin/configure-cli -a ${ip_address}
sudo /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${password}"

cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "END ---- 04-activate-cluster.sh"
