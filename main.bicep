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
param token string

// Setting target scope
targetScope = 'subscription'

// Resources
module domains './domains/main.bicep' = {
  name: 'domainsDeployment'
  params: {
    location: location
    domainName: 'rode'
    topLevelDomainName: 'io'
  }
}

// Deploying website using module
module website './website/main.bicep' = {
  name: '${prefix}-website'
  params: {
    location: location
    token: token
    name: 'domainsDeployment'
  }  
}
