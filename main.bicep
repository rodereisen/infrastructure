// =========== main.bicep ===========
// Params
@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(30)
param location string

//@minLength(3)
//@maxLength(59)
//@secure()
//param token string

// Setting target scope
targetScope = 'subscription'

// Resources

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-domains'
  location: location
}
module rodeIoDomain './domains/main.bicep' = {
  name: 'rodeIoDomain'
  scope: rg
  params: {
    domainName: 'rode'
    topLevelDomainName: 'io'
    ipv4: '5.175.14.35'
    // ipv6: '2a01:488:42:1000:50ed:8223:e6:9d2e'
  }
}

module rodereisenDeDomain './domains/main.bicep' = {
  name: 'rodereisenDeDomain'
  scope: rg
  params: {
    domainName: 'rodereisen'
    topLevelDomainName: 'de'
    ipv4: '5.175.14.35'
    // ipv6: '2a01:488:42:1000:50ed:8223:e6:9d2e'
  }
}

// Deploying website using module
//module website './website/main.bicep' = {
//  name: '${prefix}-website'
//  params: {
//    prefix: 'homepage'
//    location: location
//    token: token
//  }
//}
