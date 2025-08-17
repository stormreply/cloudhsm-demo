data "aws_availability_zones" "available" { state = "available" }
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


locals {
  account_id = data.aws_caller_identity.current.account_id
  azs        = data.aws_availability_zones.available
  region     = data.aws_region.current.region
}

resource "aws_default_subnet" "this" {
  for_each          = toset(local.azs.names)
  availability_zone = each.value
  tags = {
    Name = "Default subnet for ${each.value}"
  }
}

locals {
  default_subnets = {
    for az, subnet in aws_default_subnet.this :
    substr(az, -1, 1) => subnet.id
  }
}
  