terraform {
  required_version = ">= 1.10.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.8.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}
