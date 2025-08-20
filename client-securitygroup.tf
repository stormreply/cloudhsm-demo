
# TODO: do we still need this?
resource "aws_security_group" "client" {
  name        = "${var.deployment.name}-client"
  description = "Security group for the ${var.deployment.name} client"
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # TODO:
    ipv6_cidr_blocks = ["::/0"]      # TODO:
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
