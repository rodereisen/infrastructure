// @minLength(2)
// @maxLength(11)
// param prefix string

// @minLength(3)
// @maxLength(30)
// param location string

// Resources
// var rodeIoName = '${prefix}rodeio${uniqueString(resourceGroup().id)}'

var rodeIoName = 'rode.io'
module rodeIoDnsZone './dnszone.bicep' = {
  name: rodeIoName
  params: {
    dnsZoneName: rodeIoName
  }
}

// var rodereisenDeName = '${prefix}rodereisen${uniqueString(resourceGroup().id)}'
var rodereisenDeName = 'rodereisen.de'
resource rodereisenDe 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: rodereisenDeName
  location: 'global'
}
