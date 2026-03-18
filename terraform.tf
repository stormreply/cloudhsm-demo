terraform {

  required_version = ">= 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4"
    }
  }
}
