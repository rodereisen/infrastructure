// =========== main.bicep ===========
// Params
@minLength(2)
@maxLength(20)
param dnsZoneName string

// Resources
resource dnszone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: dnsZoneName
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

//MX Records
resource mailProtection_MX 'Microsoft.Network/dnszones/MX@2018-05-01' = {
  name: '${dnszone.name}/@'
  properties: {
    MXRecords: [
      {
        exchange: 'rode-io.mail.protection.outlook.com'
        preference: 0
      }
    ]
  }
}

// CNAME Records
resource autodiscover 'Microsoft.Network/dnszones/CNAME@2018-05-01' = {
  name: '${dnszone.name}/autodiscover'
  properties: {
    TTL: 300
    CNAMERecord: {
      cname: 'autodiscover.outlook.com'
    }
    targetResource: {}
  }
}

//TXT Records
// resource spfProtection_TXT 'Microsoft.Network/dnszones/TXT@2018-05-01' = {
//   name: '${dnszone.name}/@'
//   properties: {
//     TTL: 300
//     TXTRecords: [
//       {
//         value: [
//           'v=spf1 a:webmail.dominio.com.ni a:esa.dominio.com.ni  mx -all'
//         ]
//       }
//       {
//         value: [
//           'MS=ms36614518'
//         ]
//       }
//       {
//         value: [
//           'google-site-verification=SsrYw8Nh3cNjfo2ZRFX71RCzRRD4R0cNtKMWSpCFuyP'
//         ]
//       }
//     ]
//     targetResource: {}
//   }
// }

// A Records
// resource ARecords 'Microsoft.Network/dnszones/A@2018-05-01' = {
//   name: '${dnszone.name}/@'
//   properties: {
//     TTL: 300
//     ARecords: [
//       {
//         ipv4Address: '192.168.1.1'
//       }
//     ]
//     targetResource: {}
//   }
// }
