resource "null_resource" "pending_kms_connection" {
  provisioner "local-exec" {
    command = <<-EOF
    while [ "$CUSTOM_KEY_STORE_ID" = "" ] ; do
      sleep 5
      CUSTOM_KEY_STORE_ID=$(
        aws kms describe-custom-key-stores \
          --custom-key-store-id "${aws_kms_custom_key_store.cloudhsm.id}" \
          --query 'CustomKeyStores[].CustomKeyStoreId' \
          --output text \
        2> /dev/null
      )
      echo custom key store id: $CUSTOM_KEY_STORE_ID
    done
    echo "connecting - can take up to 20mins"
    aws kms connect-custom-key-store --custom-key-store-id "${aws_kms_custom_key_store.cloudhsm.id}"
    while [ "$CONNECTION_STATE" != "CONNECTED" ] ; do
      sleep 10
      CONNECTION_STATE=$(
        aws kms describe-custom-key-stores \
          --custom-key-store-id "${aws_kms_custom_key_store.cloudhsm.id}" \
          --query 'CustomKeyStores[].ConnectionState' \
          --output text \
        2> /dev/null
      )
      echo connection state: $CONNECTION_STATE
    done
    EOF
    quiet = true
  }
  depends_on = [
    aws_instance.cloudhsm_client
  ]
}
