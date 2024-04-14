# Network.tf: This contains the code for the VNet and subnet.

# The VNet and subnet are the property of the resource group with ${azurerm_
# resource_group.rg.name}, which tells Terraform that the VNet and subnet will be
# created just after the resource group. As for the subnet, it is dependent on its VNet with
# the use of the ${azurerm_virtual_network.vnet.name} value; it's the explicit dependence concept.
resource "azurerm_virtual_network" "vnet" {
  name                = "book-vnet"
  location            = "West Europe"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "book-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.10.0/24"]
}
