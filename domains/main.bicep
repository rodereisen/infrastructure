// @minLength(2)
// @maxLength(11)
// param prefix string

// @minLength(3)
// @maxLength(30)
// param location string

// Resources
// var rodeIoName = '${prefix}rodeio${uniqueString(resourceGroup().id)}'
var rodeIoName = 'rode.io'
resource rodeIo 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: rodeIoName
  location: 'global'
}

resource rodeIoMx 'Microsoft.Network/dnsZones/MX@2018-05-01' = {
  name: 'string'
  parent: rodeIo
  properties: {
    MXRecords: [
      {
        exchange: 'rode-io.mail.protection.outlook.com'
        preference: 0
      }
    ]
  }
}

// var rodereisenDeName = '${prefix}rodereisen${uniqueString(resourceGroup().id)}'
var rodereisenDeName = 'rodereisen.de'
resource rodereisenDe 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: rodereisenDeName
  location: 'global'
}
