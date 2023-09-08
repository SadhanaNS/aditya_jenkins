data "azurerm_client_config" "current" {

}
resource "azurerm_key_vault" "adiKV" {
  name                        = "kubeKVADI2"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = "7270ce39-4b64-4579-8f7f-93639d71f1ca"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

   access_policy {
    tenant_id = "7270ce39-4b64-4579-8f7f-93639d71f1ca"
    object_id = "7d28e8d2-18f0-4329-ab47-5d6ab45b9121"

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "List",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
  depends_on = [ azurerm_resource_group.adi-t2 ]

}
resource "azurerm_key_vault_secret" "KVS" {
    name = "kubeSecrets23"
    value = azurerm_container_registry_token.Token.name
    key_vault_id = azurerm_key_vault.adiKV.id
    depends_on = [ azurerm_key_vault.adiKV ]
  
}