#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

# create kmsuser
export CLOUDHSM_ROLE=admin
export CLOUDHSM_PIN="admin:${admin_password}"

/opt/cloudhsm/bin/cloudhsm-cli user create \
  --username kmsuser \
  --role crypto-user \
  --password "${kmsuser_password}"

echo "END ---- $(basename $0)"
