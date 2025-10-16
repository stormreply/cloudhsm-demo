
# trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows unrestricted egress to any IP address.
# trivy:ignore:AVD-AWS-0107 (HIGH): Security group rule allows unrestricted ingress from any IP address.
# trivy:ignore:AVD-AWS-0124 (LOW): Security group rule does not have a description.
resource "aws_security_group" "controller" {
  # checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
  # checkov:skip=CKV_AWS_23: "Ensure every security group and rule has a description"
  # checkov:skip=CKV_AWS_24: "Ensure no security groups allow ingress from 0.0.0.0:0 to port 22"
  # checkov:skip=CKV_AWS_382: "Ensure no security groups allow egress from 0.0.0.0:0 to port -1"
  name        = "${local._deployment}-controller"
  description = "Security group for the ${local._deployment} controller"
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
  tags = {
    Name = "${local._deployment}-controller"
  }
  lifecycle {
    create_before_destroy = true
  }

}
