#!/bin/bash -x

echo "BEGIN -- 07-copy-customer-ca-crt.sh"

instance_id=$1

echo "instance_id: ${instance_id}"

# this is for killing the PortForwardingSession; othw TF will hang
cleanup() {
  echo "Cleaning up child processes..."
  pkill -P $$
}
trap cleanup EXIT

aws ssm start-session \
  --target ${instance_id} \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["22"],"localPortNumber":["2022"]}' \
&

sleep 5

echo "start SCP"

chmod 0600 controller.pem

pwd
ls -la controller.pem
cat controller.pem

scp -i controller.pem -o StrictHostKeyChecking=no -P 2022 ec2-user@localhost:customerCA.crt customerCA.crt

echo "end SCP"

echo "END ---- 07-copy-customer-ca-crt.sh"
