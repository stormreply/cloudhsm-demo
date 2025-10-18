#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

keystore_id=$1

echo "disconnecting - can take up to 30mins"

aws kms disconnect-custom-key-store --custom-key-store-id "${keystore_id}"

while [ "$CONNECTION_STATE" != "DISCONNECTED" ] ; do
    sleep 10
    CONNECTION_STATE=$(
    aws kms describe-custom-key-stores \
        --custom-key-store-id "${keystore_id}" \
        --query 'CustomKeyStores[].ConnectionState' \
        --output text \
    2> /dev/null
    )
    echo state: $CONNECTION_STATE
done

echo "END ---- $(basename $0)"
