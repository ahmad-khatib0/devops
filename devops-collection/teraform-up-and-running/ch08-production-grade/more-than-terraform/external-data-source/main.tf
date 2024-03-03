terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}

# The external data source is a lovely escape hatch if you need to access data in your
# Terraform code and there’s no existing data source that knows how to retrieve that
# data. However, be conservative with your use of external data sources and all of the
# other Terraform “escape hatches,” since they make your code less portable and more
# brittle. For example, the external data source code you just saw relies on Bash, which
# means you won’t be able to deploy that Terraform module from Windows.
data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]

  query = {
    foo = "bar"
  }
}

output "echo" {
  value = data.external.echo.result
}

output "echo_foo" {
  value = data.external.echo.result.foo
}
