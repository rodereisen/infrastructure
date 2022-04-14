// =========== main.bicep ===========
// Params
@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(30)
param location string

@minLength(3)
@maxLength(59)
@secure()
#disable-next-line no-unused-params
param token string

@minLength(2)
@maxLength(100)
@secure()
#disable-next-line no-unused-params
param mscid string

// Variables
var ipv4 = '5.175.14.35'
var ipv6 = '2a01:488:42:1000:50ed:8223:e6:9d2e'

// Setting target scope
targetScope = 'subscription'

// Resources

//// Website
resource websiteRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-website'
  location: location
}
// module website './website/main.bicep' = {
//   name: '${prefix}-website'
//   scope: websiteRg
//   params: {
//     prefix: 'rr'
//     location: location
//     token: token
//   }
// }

//// Domains
resource domainsRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-domains'
  location: location
}
module rodeIoDomain './domains/main.bicep' = {
  name: 'rodeIoDomain'
  scope: domainsRg
  params: {
    // azureStaticWebAppName: website.outputs.siteUrl
    // azureStaticWebAppToken: '123'
    // mscid: mscid
    domainName: 'rode'
    ipv4: ipv4
    ipv6: ipv6
    topLevelDomainName: 'io'
  }
}

module rodereisenDeDomain './domains/main.bicep' = {
  name: 'rodereisenDeDomain'
  scope: domainsRg
  params: {
    // azureStaticWebAppName: website.outputs.siteUrl
    // azureStaticWebAppToken: 'v300nrt5k9zpkjk6cybkdvhfjcmg5g71'
    // mscid: mscid
    domainName: 'rodereisen'
    ipv4: ipv4
    ipv6: ipv6
    topLevelDomainName: 'de'
  }
}
