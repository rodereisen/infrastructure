// =========== main.bicep ===========

// Params
@minLength(2)
@maxLength(20)
param location string

@minLength(2)
@maxLength(20)
param domainName string

@minLength(2)
@maxLength(20)
param topLevelDomainName string

// Resources
var dns = '${domainName}.${topLevelDomainName}'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${domainName}-${topLevelDomainName}-domains'
  location: location
}

module dnsZone './dnszone.bicep' = {
  name: dns
  scope: rg
  params: {
    dnsZoneName: dns
  }
}

