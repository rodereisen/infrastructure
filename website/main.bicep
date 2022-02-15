// Params

@minLength(3)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(11)
param location string

@description('Enter your GitHub PAT')
@secure()
param token string

var repositoryUrl = 'https://github.com/rodereisen/rodereisen-de'
var branch = 'main'
var appArtifactLocation = 'https://github.com/rodereisen/rodereisen-de'
var namePrefix = 'website'

// Vars

var siteName = '${namePrefix}${uniqueString(resourceGroup().id)}'
var sku = 'Free'

// Create the Static Site

resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  location: location
  name: siteName
  properties: {
    buildProperties:{
      appArtifactLocation: appArtifactLocation
    }
    repositoryUrl: repositoryUrl
    branch: branch
    repositoryToken: token
  }
  sku:{
    name: sku
  }
}

// Output
output siteName string = staticSite.name
output siteUrl string = staticSite.properties.defaultHostname

output deployment_token string = listSecrets(staticSite.id, staticSite.apiVersion).properties.apiKey
