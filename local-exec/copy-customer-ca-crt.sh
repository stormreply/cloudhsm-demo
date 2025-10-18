#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

instance_id=$1

echo "instance_id: ${instance_id}"

aws ssm start-session \
  --target ${instance_id} \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["22"],"localPortNumber":["2022"]}' \
> /tmp/ssm-tunnel.log 2>&1 &

SSM_PID=$!

sleep 5
chmod 0600 controller.pem
scp -i controller.pem -o StrictHostKeyChecking=no -P 2022 ec2-user@localhost:customerCA.crt customerCA.crt
kill $SSM_PID
wait $SSM_PID || true

# cat /tmp/ssm-tunnel.log

echo "END ---- $(basename $0)"
