#!/bin/bash -x

echo "BEGIN -- 04-activate-cluster.sh"

# copy customerCA.crt to config location for configure- and cloudhsm-cli
cp customerCA.crt /opt/cloudhsm/etc/customerCA.crt

# copy customerCA.crt to /home/ec2-user for later download
cp customerCA.crt /home/ec2-user/customerCA.crt

# activate cluster
sudo /opt/cloudhsm/bin/configure-cli -a ${ip_address}
sudo /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${password}"

cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "END ---- 04-activate-cluster.sh"
