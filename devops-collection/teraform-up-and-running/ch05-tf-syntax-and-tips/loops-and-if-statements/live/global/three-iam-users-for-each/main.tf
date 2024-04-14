terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# The fact that you now have a map of resources with for_each rather than an array of resources as with 
# count is a big deal, because it allows you to remove items from the middle of a collection safely.
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

