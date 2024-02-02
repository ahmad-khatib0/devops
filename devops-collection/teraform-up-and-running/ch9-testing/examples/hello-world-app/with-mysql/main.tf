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

module "hello_world_app" {
  source = "../../../modules/services/hello-world-app"

  server_text            = var.server_text
  environment            = var.environment

  # Pass all the outputs from the mysql module straight through!
  # so this is the benfit of defining the mysql_config variable as an object
  # So Because the type of mysql_config matches the type of the mysql module outputs,
  # you can pass them all straight through in one line. And if the types are ever changed
  # and no longer match, Terraform will give you an error right away so that you know to update 
  # them. This is not only function composition at work but also type-safe function composition.
  mysql_config = module.mysql

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
  ami                = data.aws_ami.ubuntu.id
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
