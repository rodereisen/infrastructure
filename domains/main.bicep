// @minLength(2)
// @maxLength(11)
// param prefix string

@minLength(2)
@maxLength(20)
param domainName string

@minLength(2)
@maxLength(20)
param topLevelDomainName string

// Resources
var dns = '${prefix}rodeio${uniqueString(resourceGroup().id)}'

module dnsZone './dnszone.bicep' = {
  name: '${dns}'
  params: {
    dnsZoneName: name: '${dns}'
  }
}