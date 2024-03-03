terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "example" {
  # Use UUID to force this null_resource to be recreated on every
  # call to 'terraform apply'
  triggers = {
    # triggers, which takes in a map of keys and values. Whenever the values change, the null_resource 
    # will be re-created, therefore forcing any provisioners within it to be reexecute
    uuid = uuid()
  }

  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
}
