terraform {
  source = "../../../../modules//data-stores/mysql"
}

# The include block finds the root terragrunt.hcl using the Terragrunt built-in function find_in_parent_folders(), 
# automatically inheriting all the settings from that parent file, including the remote_state configuration. 
# The result is that this mysql module will use all the same backend settings as the root file, and the key value 
# will automatically resolve to data-stores/mysql/terraform.tfstate. This means that your Terraform state will be 
# stored in the same folder structure as your live repo, which will make it
# easy to know which module produced which state files.

include {
  path = find_in_parent_folders()
}

inputs = {
  db_name = "example_stage"

  # Set the username using the TF_VAR_db_username environment variable
  # Set the password using the TF_VAR_db_password environment variable
}

# When you run terragrunt apply and it finds the source parameter in a terragrunt.hcl file, Terragrunt will do the following:
# 1. Check out the URL specified in source to a temporary folder. This supports the same URL syntax as the source 
#    parameter of Terraform modules, so you can use local file paths, Git URLs, versioned Git URLs 
#    (with a ref parameter, as in the preceding example), and so on.
#
# 2. Run terraform apply in the temporary folder, passing it the input variables that
#    you’ve specified in the inputs = { ... } block.


# terragrunt apply --terragrunt-log-level debug
#
# DEBU[0001] Reading Terragrunt config file at terragrunt.hcl
# DEBU[0001] Included config live/stage/terragrunt.hcl
# DEBU[0001] Downloading Terraform configurations into .terragrunt-cache
# DEBU[0001] Generated file backend.tf
# DEBU[0013] Running command: terraform init
# (...)
# Initializing the backend...
# Successfully configured the backend "s3"! Terraform will automatically
# use this backend unless the backend configuration changes.
# (...)
# DEBU[0024] Running command: terraform apply
# (...)
# Terraform will perform the following actions:
# (...)
#
# Plan: 5 to add, 0 to change, 0 to destroy.
# Do you want to perform these actions?
#   Terraform will perform the actions described above.
#   Only 'yes' will be accepted to approve.
#   Enter a value: yes
# (...)
# Apply complete! Resources: 5 added, 0 changed, 0 destroyed.


# using the --terragrunt-log-level debug, the preceding output shows what Terra‐ grunt does under the hood:
# 1. Read the terragrunt.hcl file in the mysql folder where you ran apply.
# 2. Pull in all the settings from the included root terragrunt.hcl file.
# 3. Download the Terraform code specified in the source URL into the .terragruntcache scratch folder.
# 4. Generate a backend.tf file with your backend configuration.
# 5. Detect that init has not been run and run it automatically (Terragrunt will even
#    create your S3 bucket and DynamoDB table automatically if they don’t already exist).
# 6. Run apply to deploy changes.



