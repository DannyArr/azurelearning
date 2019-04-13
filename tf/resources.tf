provider "azurerm" {
  version = "=1.24.0"

  subscription_id = "58e9b4ed-7799-4271-b6e7-77f7766491e0"
  client_id       = "2c72ede8-54c7-48e2-ba76-17f46fb3dea5"
  client_secret   = "edeed3d6-e8c5-4a05-abcd-7fdc7fd51e53"
  tenant_id       = "60fa6c9d-6c53-4644-9482-9fb65f9d0de9"
}

resource "azurerm_resource_group" "test" {
  name = "DansTest"
  location = "West Europe"

  tags = {
      learning = "Azure"
  }
}
