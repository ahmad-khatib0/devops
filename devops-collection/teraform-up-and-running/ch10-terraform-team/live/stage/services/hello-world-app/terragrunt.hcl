terraform {
  source = "../../../../modules//services/hello-world-app"
}

include {
  path = find_in_parent_folders()
}

# dependency: This is a Terragrunt feature that can be used to automatically read the output vari‐
# ables of another Terragrunt module, so you can pass them as input variables to the
# current module, as follows:  mysql_config = dependency.mysql.outputs
#
# In other words, dependency blocks are an alternative to using terraform_remote_state data sources to pass 
# data between modules. While terra form_remote_state data sources have the advantage of being native to Terraform,
# the drawback is that they make your modules more tightly coupled together, as each module needs to know how other 
# modules store state. Using Terragrunt dependency blocks allows your modules to expose generic inputs like 
# mysql_config and vpc_id, instead of using data sources, which makes the modules less tightly coupled and
# easier to test and reuse.
dependency "mysql" {
  config_path = "../../data-stores/mysql"
}

inputs = {
  environment = "stage"
  ami         = "ami-0fb653ca2d3203ac1"

  min_size = 2
  max_size = 2

  enable_autoscaling = false

  mysql_config = dependency.mysql.outputs
}
