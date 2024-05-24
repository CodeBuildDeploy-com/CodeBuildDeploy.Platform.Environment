resource "azurerm_network_watcher" "cbd_subscription_traffic_watcher" {
  name                = "cbd-${var.subscription_short_name}-NetworkWatcher"
  location            = azurerm_resource_group.cbd_subscription_rg.location
  resource_group_name = azurerm_resource_group.cbd_subscription_rg.name
}