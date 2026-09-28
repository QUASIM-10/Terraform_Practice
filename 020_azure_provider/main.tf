terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "terraform_azure_providers" {
  name     = "terraform_azure_provider"
  location = "UK South"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for the VM"
  type        = string
  default     = "~/.ssh/terraform.pub"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  ssh_key             = var.ssh_public_key_path
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["quasimvm2026"]
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_D2s_v3"
  depends_on          = [azurerm_resource_group.terraform_azure_providers]

  public_ip_sku     = "Standard"
  allocation_method = "Static"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on   = [azurerm_resource_group.terraform_azure_providers]
  use_for_each = true
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}
