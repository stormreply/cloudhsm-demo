#!/bin/bash -x

echo "BEGIN -- 07-copy-customer-ca-crt.sh"

instance_id=$1

aws ssm start-session \
  --target ${instance_id} \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["22"],"localPortNumber":["2022"]}' \
&

sleep 5

scp -P 2022 -o StrictHostKeyChecking=no ec2-user@localhost:customerCA.crt customerCA.crt

echo "END ---- 07-copy-customer-ca-crt.sh"
