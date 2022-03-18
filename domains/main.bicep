@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(11)
param location string

// Resources
var rodeIoName = '${prefix}rodeio${uniqueString(resourceGroup().id)}'
resource rodeIo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: rodeIoName
  location: location
}

var rodereisenDeName = '${prefix}rodereisen${uniqueString(resourceGroup().id)}'
resource rodereisenDe 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: rodereisenDeName
  location: location
}
