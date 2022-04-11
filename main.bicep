// =========== main.bicep ===========
// Params
@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(30)
param location string

// @minLength(3)
// @maxLength(59)
// param token string

// Setting target scope
targetScope = 'subscription'

// Resources
module domains './domains/main.bicep' = {
  name: 'domainsDeployment'
  scope: domainsRg
  location: location
  domainName: 'rode'
  topLevelDomainName: 'io'
}

// Deploying website using module
resource websiteRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-website'
  location: location
}
// module website './website/main.bicep' = {
//   name: 'websiteDeployment'
//   scope: websiteRg
//   params: {
//     prefix: prefix
//     location: location
//     token: token
//   }
// }
