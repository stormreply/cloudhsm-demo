# resource "null_resource" "cluster_active" {

#   triggers = {
#     name = var.deployment.name
#   }

#   provisioner "local-exec" {
#     when    = create
#     quiet   = false
#     command = "bash ./scripts/07-copy-customer-ca-crt.sh $instance_id"
#     environment = {
#       instance_id = module.controller.
#     }
#   }

#   depends_on = [
#     null_resource.cluster_active,
#     module.controller
#   ]
# }
