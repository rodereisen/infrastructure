param appName string

@maxLength(24)
param vaultName string = '${'kv-'}${appName}-${substring(uniqueString(resourceGroup().id), 0, 23 - (length(appName) + 3))}' // must be globally unique
param location string = resourceGroup().location
param sku string = 'Standard'
param tenantId string // replace with your tenantId

param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true
param enableRbacAuthorization bool = true
param softDeleteRetentionInDays int = 90

param networkAcls object = {
  ipRules: []
  virtualNetworkRules: []
}

var appSuffix = substring(uniqueString(resourceGroup().id), 0, 4)

resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: '${vaultName}${appSuffix}'
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: sku
    }
    //accessPolicies: accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    networkAcls: networkAcls
  }
}

output keyVaultName string = keyvault.name
output keyVaultId string = keyvault.id
