// Params
@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(30)
param location string

@description('Enter your GitHub PAT')
@secure()
param token string

// Vars
var repositoryUrl = 'https://github.com/rodereisen/rodereisen-de'
var branch = 'main'
var appArtifactLocation = 'src'
var siteName = '${prefix}-rodereisen-de'
var skuName = 'Free'
var skuTier = 'Free'
var appLocation = '/'
var apiLocation = ''

// Resources
// Create the Static Site
resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: siteName
  location: location
  properties: {
    buildProperties: {
      appLocation: appLocation
      apiLocation: apiLocation
      appArtifactLocation: appArtifactLocation
    }
    repositoryUrl: repositoryUrl
    branch: branch
    repositoryToken: token
  }
  sku: {
    name: skuName
    tier: skuTier
  }
}

resource azStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${siteName}-function-app-storage'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
var azStorageAccountPrimaryAccessKey = listKeys(azStorageAccount.id, azStorageAccount.apiVersion).keys[0].value

// Output
output siteName string = staticSite.name
output siteUrl string = staticSite.properties.defaultHostname
// output deployment_token string = listSecrets(staticSite.id, staticSite.apiVersion).properties.apiKey


