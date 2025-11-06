provider "aws" {
  default_tags {
    tags = local._default_tags
  }
}

provider "aws" {
  alias = "controller"
  default_tags {
    tags = merge(
      local._default_tags,
      {
        deployment-name = "${local._name_tag}-controller"
      }
    )
  }
}
