# Rg.tf: This contains the code for the resource group.

resource "azurerm_resource_group" "rg" {
  # An internal Terraform ID (for example, rg)
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "Terraform Azure"
  }
}
