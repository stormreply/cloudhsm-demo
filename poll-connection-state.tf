resource "null_resource" "poll_connection_state" {

  triggers = {
    name = local._deployment
  }

  provisioner "local-exec" {
    when    = create
    quiet   = false
    command = "bash ./scripts/08-poll-connection-state.sh $keystore_id"
    environment = {
      keystore_id = aws_kms_custom_key_store.cloudhsm.id
    }
  }
}
