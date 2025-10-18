#!/bin/bash -x

echo "BEGIN -- 04-activate-cluster.sh"

# copy customer-ca.crt to config location for configure- and cloudhsm-cli
cp customer-ca.crt /opt/cloudhsm/etc/customer-ca.crt

# copy customer-ca.crt to /home/ec2-user for later download
cp customer-ca.crt /home/ec2-user/customer-ca.crt

# activate cluster
sudo /opt/cloudhsm/bin/configure-cli -a ${ip_address}
sudo /opt/cloudhsm/bin/cloudhsm-cli cluster activate --password "${password}"

cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "END ---- 04-activate-cluster.sh"
