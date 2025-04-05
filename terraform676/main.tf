provider "azurerm" {
  features {}
  subscription_id = "070c4cac-c20e-4008-9a23-a47c92d17f7e"
}

resource "azurerm_resource_group" "rgas" {
  name     = "rg-integrated-terraform"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "khushapp_service_plan"
  location            = azurerm_resource_group.rgas.location
  resource_group_name = azurerm_resource_group.rgas.name

  sku {
    tier = "Basic"
    size = "S1"
  }
}

resource "azurerm_app_service" "my-app_service" {
  name                = "khushapijenkins5673"
  location            = azurerm_resource_group.rgas.location
  resource_group_name = azurerm_resource_group.rgas.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id


  site_config {
  linux_fx_version = "NODE|20"  # or your desired Node.js version
  scm_type         = "LocalGit"     # or "GitHub" / "VSTSRM" / "None" etc.
}

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
