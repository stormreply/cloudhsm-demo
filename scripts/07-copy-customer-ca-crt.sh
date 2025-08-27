#!/bin/bash -x

echo "BEGIN -- 07-copy-customer-ca-crt.sh"

instance_id=$1

echo "instance_id: ${instance_id}"

aws ssm start-session \
  --target ${instance_id} \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["22"],"localPortNumber":["2022"]}' \
&

sleep 5

echo "start SCP"

scp -i controller.pem -o StrictHostKeyChecking=no -P 2022 ec2-user@localhost:customerCA.crt customerCA.crt

echo "end SCP"
pwd
ls -la controller.pem
cat controller.pem

echo "END ---- 07-copy-customer-ca-crt.sh"
