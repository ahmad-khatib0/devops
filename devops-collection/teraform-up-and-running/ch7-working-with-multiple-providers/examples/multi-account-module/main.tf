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
  alias  = "parent"
}

provider "aws" {
  region = "us-east-2"
  alias  = "child"

  assume_role {
    role_arn = var.child_iam_role_arn
  }
}

# The keys in the providers map must match the names of the configuration aliases within the module; if 
# any of the names from configuration aliases are missing in the providers map, Terraform will show an error.
# This way, when you’re building a reusable module, you can define what providers that module needs, and Terraform
# will ensure users pass those providers in; and when you’re building a root module, you can define 
# your provider blocks just once and pass around references to them to the reusable modules you depend on.
module "multi_account_example" {
  source = "../../modules/multi-account"

  providers = {
    aws.parent = aws.parent
    aws.child  = aws.child
  }
}
