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

# Note the use of toset to convert the var.user_names list into a set. This is because
# for_each supports sets and maps only when used on a resource. When for_each loops over this 
# set, it makes each username available in each.value. The username will also be available in 
# each.key, though you typically use each.key only with maps of key-value pairs.
#
# Once you’ve used for_each on a resource, it becomes a map of resources, rather
# than just one resource (or an array of resources as with count).
module "users" {
  source = "../../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.value
}
