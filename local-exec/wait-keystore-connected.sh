#!/bin/bash -x

echo "BEGIN -- $(basename $0)"

keystore_id=$1

while [ "$CUSTOM_KEY_STORE_ID" = "" ] ; do
    sleep 5
    CUSTOM_KEY_STORE_ID=$(
    aws kms describe-custom-key-stores \
        --custom-key-store-id "${keystore_id}" \
        --query 'CustomKeyStores[].CustomKeyStoreId' \
        --output text \
    2> /dev/null
    )
    echo custom key store id: $CUSTOM_KEY_STORE_ID
done

echo "connecting - can take up to 30mins"

aws kms connect-custom-key-store --custom-key-store-id "${keystore_id}"

while [ "$CONNECTION_STATE" != "CONNECTED" ] ; do
    sleep 10
    CONNECTION_STATE=$(
    aws kms describe-custom-key-stores \
        --custom-key-store-id "${keystore_id}" \
        --query 'CustomKeyStores[].ConnectionState' \
        --output text \
    2> /dev/null
    )
    echo connection state: $CONNECTION_STATE
done

echo "END ---- $(basename $0)"
