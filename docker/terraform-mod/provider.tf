terraform {
  required_version = "~> 1.9.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}

provider "aws" {
  region = var.region
}
