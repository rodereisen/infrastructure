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
@maxLength(40)
param ipv4 string

// @minLength(2)
// @maxLength(40)
// param ipv6 string

// Variables
var mscid = 'amUzpW6lC6BwVZC+9LgXvoF+EgM63n1M0rlXX28RoJrOoe1vhPmLipWtk9KC5uFfRR0hx03v/oKhFjk/uoxVYQ=='
var ttl = 3600

// Resources
resource dnszone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: '${domainName}.${topLevelDomainName}'
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

// A Records
resource homeDomain 'Microsoft.Network/dnszones/A@2018-05-01' = {
  name: '${dnszone.name}/@'
  properties: {
    TTL: ttl
    ARecords: [
      {
        ipv4Address: ipv4
      }
    ]
    targetResource: {}
  }
}

// CNAME Records
resource www 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/www'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'black-pebble-0f29bd703.azurestaticapps.net'
    }
    targetResource: {}
  }
}
resource msoid 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/msoid'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'clientconfig.microsoftonline-p.net'
    }
    targetResource: {}
  }
}
resource autodiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/autodiscover'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'autodiscover.hornetsecurity.com'
    }
    targetResource: {}
  }
}
resource sip 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/sip'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'sipdir.online.lync.com'
    }
    targetResource: {}
  }
}
resource lyncdiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/lyncdiscover'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'webdir.online.lync.com'
    }
    targetResource: {}
  }
}
resource enterpriseregistration 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/enterpriseregistration'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'enterpriseregistration.windows.net'
    }
    targetResource: {}
  }
}
resource enterpriseenrollment 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/enterpriseenrollment'
  properties: {
    TTL: ttl
    CNAMERecord: {
      cname: 'enterpriseenrollment.manage.microsoft.com'
    }
    targetResource: {}
  }
}

// MX Records
resource mailProtection_MX 'Microsoft.Network/dnszones/MX@2018-05-01' = {
  name: '${dnszone.name}/@'
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
resource spf 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  name: '${dnszone.name}/@'
  properties: {
    TTL: ttl
    TXTRecords: [
      {
        value: [
          'v=spf1 include:spf.protection.outlook.com include:spf.hornetsecurity.com -all'
          'mscid=${mscid}'
        ]
      }
    ]
  }
}

// TXT Records
resource srvSip 'Microsoft.Network/dnsZones/SRV@2018-05-01' = {
  name: '${dnszone.name}/_sip._tls'
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
resource srvSipFederation 'Microsoft.Network/dnsZones/SRV@2018-05-01' = {
  name: '${dnszone.name}/_sipfederationtls._tcp'
  properties: {
    TTL: ttl
    SRVRecords: [
      {
        port: 443
        priority: 100
        target: 'sipfed.online.lync.com'
        weight: 1
      }
    ]
  }
}
