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

// Output
output siteName string = staticSite.name
output siteUrl string = staticSite.properties.defaultHostname
// output deployment_token string = listSecrets(staticSite.id, staticSite.apiVersion).properties.apiKey
