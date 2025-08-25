#!/bin/bash

echo "BEGIN -- 01-install-cloudhsm-cli.sh"

# get CloudHSM CLI for client instance on Amazon Linux 2023, cf. https://docs.aws.amazon.com/cloudhsm/latest/userguide/w20aac23c15c13b7.html
wget https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/Amzn2023/cloudhsm-cli-latest.amzn2023.x86_64.rpm
sudo yum install -y ./cloudhsm-cli-latest.amzn2023.x86_64.rpm

ls -la /opt/cloudhsm/
ls -la /opt/cloudhsm/etc
ls -la /opt/cloudhsm/etc/cloudhsm-cli.cfg
cat /opt/cloudhsm/etc/cloudhsm-cli.cfg

echo "END ---- 01-install-cloudhsm-cli.sh"
