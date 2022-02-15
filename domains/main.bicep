@minLength(3)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(11)
param location string

resource rodeIo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: '${prefix}-rode-io'
  location: location
}

resource rodereisenDe 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: '${prefix}-rodereisen-de'
  location: location
}
