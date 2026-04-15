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

seconds=0

while [ $seconds -lt 3600 ] ; do
    CONNECTION_STATE=$(
    aws kms describe-custom-key-stores \
        --custom-key-store-id "${keystore_id}" \
        --query 'CustomKeyStores[].ConnectionState' \
        --output text \
    2> /dev/null
    )
    echo connection state: $CONNECTION_STATE
    [ "$CONNECTION_STATE" = "CONNECTED" ] && break
    [ "$CONNECTION_STATE" = "FAILED" ]    && exit 1
    seconds=$((seconds + 10))
    sleep 10
done

echo "END ---- $(basename $0)"
