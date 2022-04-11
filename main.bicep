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
module rodeIoDomain './domains/main.bicep' = {
  name: 'rodeIoDomain'
  params: {
    location: location
    domainName: 'rode'
    topLevelDomainName: 'io'
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
