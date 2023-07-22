resource random_string main {
  length  = 8
  upper   = false
  special = false

}


resource azurerm_resource_group main {
  name     = "rg-${random_string.main.result}"
  location = var.location
}

resource azurerm_virtual_network VNet1 {
  name                = "Vnet-${random_string.main.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

}

resource azurerm_subnet Subnet1 {
  name                 = "Snet-${random_string.main.result}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = ["10.0.1.0/24"]

  }

resource azurerm_network_security_group NSG1 {
  name                = "nsg-deafault1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

}

resource azurerm_network_security_rule rule1 {
  name                        = "Rule-100"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.NSG1.name
}

resource azurerm_subnet_network_security_group_association example {
  subnet_id                 = azurerm_subnet.Subnet1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}