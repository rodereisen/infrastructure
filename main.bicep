@minLength(3)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(11)
param location string

// =========== main.bicep ===========

// Setting target scope
targetScope = 'subscription'

// Creating resource group
resource domainsRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-domains'
  location: location
}

// Creating resource group
resource websiteRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-website'
  location: location
}

// Deploying domains using module
module domains './website/main.bicep' = {
  name: 'domainsDeployment'
  scope: domainsRg
  params: {
    prefix: prefix
    location: location
  }
}
// Deploying storage account using module
module website './website/main.bicep' = {
  name: 'websiteDeployment'
  scope: websiteRg
  params: {
    prefix: prefix
    location: location
  }
}
