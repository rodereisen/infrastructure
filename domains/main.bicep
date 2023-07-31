// =========== main.bicep ===========

// Params
// @minLength(2)
// @maxLength(4)
// param prefix string

// @minLength(2)
// @maxLength(20)
// param location string

@minLength(2)
@maxLength(20)
param domainName string

@minLength(2)
@maxLength(40)
param topLevelDomainName string

@minLength(2)
@maxLength(100)
param mscid string

@minLength(2)
@maxLength(100)
param azureStaticWebAppName string

@minLength(2)
@maxLength(100)
#disable-next-line no-unused-params
param azureStaticWebResourceName string

@minLength(2)
@maxLength(100)
#disable-next-line no-unused-params
param azureStaticWebResourceGroupName string

// @minLength(2)
// @maxLength(100)
// param azureStaticWebAppToken string
// Variables
var ttl = 600

// var apexresourceId = subscriptionResourceId('Microsoft.Web/staticSites', azureStaticWebResourceGroupName, azureStaticWebResourceName)
var apexresourceId = '/subscriptions/9696009b-e3a7-4a9f-b9a4-70b155ec5b87/resourceGroups/rodereisen-de/providers/Microsoft.Web/staticSites/rodereisen-de'

param deployM365 bool

// Resources
resource dnszone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: '${domainName}.${topLevelDomainName}'
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
resource apex 'Microsoft.Network/dnszones/A@2018-05-01' = {
  name: '@'
  parent: dnszone
  properties: {
    TTL: ttl
    ARecords: []
    targetResource: {
      id: apexResourceId
    }
  }
}
resource www 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'www'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: azureStaticWebAppName
    }
    targetResource: {}
  }
}
resource msoid 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'msoid'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'clientconfig.microsoftonline-p.net'
    }
    targetResource: {}
  }
}
// resource autodiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
//   name: '${dnszone.name}/autodiscover'
//   properties: {
//     TTL: ttl
//     CNAMERecord: {
//       cname: 'autodiscover.outlook.com'
//     }
//     targetResource: {}
//   }
// }
resource autodiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'autodiscover'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'autodiscover.hornetsecurity.com'
    }
    targetResource: {}
  }
}
resource sip 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'sip' 
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'sipdir.online.lync.com'
    }
    targetResource: {}
  }
}
resource lyncdiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'lyncdiscover'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'webdir.online.lync.com'
    }
    targetResource: {}
  }
}
resource enterpriseregistration 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'enterpriseregistration'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'enterpriseregistration.windows.net'
    }
    targetResource: {}
  }
}
resource enterpriseenrollment 'Microsoft.Network/dnszones/CNAME@2018-05-01' = if (deployM365) {
  name: 'enterpriseenrollment'
  parent: dnszone
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'enterpriseenrollment.manage.microsoft.com'
    }
    targetResource: {}
  }
}
// MX Records
// resource mailProtection_MX 'Microsoft.Network/dnszones/MX@2018-05-01' = if (deployM365) {
//   name: '${dnszone.name}/@'
//   properties: {
//     TTL: ttl
//     MXRecords: [
//       {
//         exchange: '${domainName}-${topLevelDomainName}.mail.protection.outlook.com'
//         preference: 10
//       }
//     ]
//   }
// }
resource mailProtection_MX 'Microsoft.Network/dnszones/MX@2018-05-01' = if (deployM365) {
  name: '@'
  parent: dnszone
  properties: {
    TTL: ttl
    MXRecords: [
      {
        exchange: 'mx01.hornetsecurity.com'
        preference: 10
      }
      {
        exchange: 'mx02.hornetsecurity.com'
        preference: 20
      }
      {
        exchange: 'mx03.hornetsecurity.com'
        preference: 30
      }
      {
        exchange: 'mx04.hornetsecurity.com'
        preference: 40
      }
    ]
  }
}
// TXT Records
resource txtRecords 'Microsoft.Network/dnsZones/TXT@2018-05-01' = if (deployM365) {
  name: '@'
  parent: dnszone
  properties: {
    TTL: ttl
    TXTRecords: [
      {
        value: [
          'mscid=${mscid}'
        ]
      }
      {
        value: [
          'v=spf1 include:spf.protection.outlook.com include:spf.hornetsecurity.com -all'
        ]
      }
    ]
  }
}
// SRV Records
resource srvSip 'Microsoft.Network/dnsZones/SRV@2018-05-01' = if (deployM365) {
  name: '_sip._tls'
  parent: dnszone
  properties: {
    TTL: ttl
    SRVRecords: [
      {
        port: 443
        priority: 100
        target: 'sipdir.online.lync.com'
        weight: 1
      }
    ]
  }
}
resource srvSip2 'Microsoft.Network/dnsZones/SRV@2018-05-01' = if (deployM365) {
  name: 'sip._tls'
  parent: dnszone
  properties: {
    TTL: ttl
    SRVRecords: [
      {
        port: 443
        priority: 100
        target: 'sipdir.online.lync.com'
        weight: 1
      }
    ]
  }
}
resource srvSipFederation 'Microsoft.Network/dnsZones/SRV@2018-05-01' = if (deployM365) {
  name: '_sipfederationtls._tcp'
  parent: dnszone
  properties: {
    TTL: ttl
    SRVRecords: [
      {
        port: 5061
        priority: 100
        target: 'sipfed.online.lync.com'
        weight: 1
      }
    ]
  }
}
resource srvSipFederation2 'Microsoft.Network/dnsZones/SRV@2018-05-01' = if (deployM365) {
  name: 'sipfederationtls._tcp'
  parent: dnszone
  properties: {
    TTL: ttl
    SRVRecords: [
      {
        port: 5061
        priority: 100
        target: 'sipfed.online.lync.com'
        weight: 1
      }
    ]
  }
}
