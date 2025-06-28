# Outputs
output "storageid" {
  value = azurerm_storage_account.this.id
}
output "storagename" {
  value = azurerm_storage_account.this.name
}

output "bloburi" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}
