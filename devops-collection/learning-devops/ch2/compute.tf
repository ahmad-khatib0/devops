# Compute.tf: This contains the code for the network interface, public IP, storage, and virtual machine.
#


# the Terraform provisioning code of the virtual machine, which is composed of the following:
# • A network interface
# • A public IP address
# • An Azure Storage object for the diagnostic boot (boot information logs)
# • A virtual machine

resource "azurerm_network_interface" "nic" {
  name                = "book-nic"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "bookipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# we configure the dynamic allocation of the IP address and the DNS label.
resource "azurerm_public_ip" "pip" {
  name                = "book-ip"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic" # Defines the allocation method for this IP 
  domain_name_label   = "bookdevops"
}

resource "azurerm_storage_account" "stor" {
  name                     = "bookstor"
  location                 = "West Europe"
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_virtual_machine" "vm" {
  name                  = "bookvm"
  location              = "West Europe"
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "book-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "VMBOOK"
    admin_username = "admin"
    admin_password = "book123*"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.stor.primary_blob_endpoint
    # The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files
  }
}
