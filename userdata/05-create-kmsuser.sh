#!/bin/bash -x

echo "BEGIN -- 05-create-kmsuser.sh"

# create kmsuser
export CLOUDHSM_ROLE=admin
export CLOUDHSM_PIN="admin:${admin_password}"

/opt/cloudhsm/bin/cloudhsm-cli user create \
  --username kmsuser \
  --role crypto-user \
  --password "${kmsuser_password}"
EOF

echo "END ---- 05-create-kmsuser.sh"
