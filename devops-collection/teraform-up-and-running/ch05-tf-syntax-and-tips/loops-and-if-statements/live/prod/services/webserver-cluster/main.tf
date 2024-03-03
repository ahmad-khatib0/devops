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

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner     = "team-foo"
      ManagedBy = "Terraform"
    }
  }
  # The preceding code will ensure that every single AWS resource you create in this
  # module will include the Owner and ManagedBy tags (the only exceptions are resources
  # that don’t support tags and the aws_autoscaling_group resource, which does support
  # tags but doesn’t work with default_tags
}

# another advantage of for_each: its ability to create multiple inline blocks within a resource. 
# For example, you can use for_each to dynamically generate tag inline blocks for the ASG in the
# webserver-cluster module. First, to allow users to specify custom tags
module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
    # this infrastructure is managed using Terraform (indicating that this 
    # infrastructure shouldn’t be modified manually)
  }

}

