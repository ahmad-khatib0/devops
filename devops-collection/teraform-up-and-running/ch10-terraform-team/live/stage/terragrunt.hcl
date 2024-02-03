terragrunt_version_constraint = ">= v0.36.0"

# Terragrunt also helps you keep your backend configuration DRY. Instead of having
# to define the bucket, key, dynamodb_table, and so on in every single module, you
# can define it in a single terragrunt.hcl file per environment. For example:
# 
# From this one remote_state block, Terragrunt can generate the backend configura‐tion dynamically for each of 
# your modules, writing the configuration in config to the file specified via the generate param. Note that the 
# key value in config uses a Terragrunt built-in function called path_relative_to_include(), which will return the
# relative path between this root terragrunt.hcl file and any child module that includes it
# 
# For example, to include this root file in live/stage/data-stores/mysql/terragrunt.hcl, see the include block
# in live/stage/data-stores/mysql/terragrunt.hcl
remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = get_env("TEST_STATE_S3_BUCKET", "")
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("TEST_STATE_REGION", "")
    encrypt        = true
    dynamodb_table = get_env("TEST_STATE_DYNAMODB_TABLE", "")

  }
}
