terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "4.12.0"
    }
  }
  required_version = ">= 0.13"
}

provider "okta" {}