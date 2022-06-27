// =========== main.bicep ===========
// Params
@minLength(2)
@maxLength(11)
param prefix string

@minLength(3)
@maxLength(30)
param location string

@minLength(3)
@maxLength(59)
@secure()
#disable-next-line no-unused-params
param token string

@minLength(2)
@maxLength(100)
@secure()
#disable-next-line no-unused-params
param mscid string

@minLength(2)
@maxLength(100)
#disable-next-line no-unused-params
param deploymentOperatorId string

// Variables
#disable-next-line no-unused-params
var azureStaticWebAppName = 'black-pebble-0f29bd703.azurestaticapps.net'
#disable-next-line no-unused-params
var ipv4 = '5.175.14.35'
#disable-next-line no-unused-params
var ipv6 = '2a01:488:42:1000:50ed:8223:e6:9d2e'

// Setting target scope
targetScope = 'subscription' // a 4-char suffix to add to the various names of azure resources to help them be unique, but still, previsible

// Resources
var salt = 5
var appSuffix = substring(uniqueString('${paxConnectExporterRg.id}${salt}'), 0, 5)

//// Website
resource websiteRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-website'
  location: location
}

// module website './website/main.bicep' = {
//   name: '${prefix}-website'
//   scope: websiteRg
//   params: {
//     prefix: 'rr'
//     location: location
//     token: token
//   }
// }

//// Domains
resource domainsRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-domains'
  location: location
}

module rodereisenDeDomain './domains/main.bicep' = {
  name: 'rodereisenDeDomain'
  scope: domainsRg
  params: {
    azureStaticWebAppName: azureStaticWebAppName
    // azureStaticWebAppName: website.outputs.siteUrl
    // azureStaticWebAppToken: 'v300nrt5k9zpkjk6cybkdvhfjcmg5g71'
    mscid: mscid
    domainName: 'rodereisen'
    ipv4: ipv4
    ipv6: ipv6
    topLevelDomainName: 'de'
  }
}

//// Paxconnect Exporter
// param appName string = 'paxconnect-exporter'
// param tenantId string = tenant().tenantId

// resource paxConnectExporterRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
//   name: '${prefix}-paxconnect-exporter-${substring(uniqueString('${location}${salt}'), 0, 5)}'
//   location: location
// }

// module operatorSetup 'operator-setup/main.bicep' = {
//   name: 'operatorSetup-deployment'
//   scope: paxConnectExporterRg
//   params: {
//     operatorPrincipalId: deploymentOperatorId
//     appName: appName
//   }
// }

// var managedIdentityName = 'msi-${appSuffix}'
// module msi 'msi/main.bicep' = {
//   name: 'msi-deployment'
//   scope: paxConnectExporterRg
//   params: {
//     location: location
//     managedIdentityName: managedIdentityName
//     operatorRoleDefinitionId: operatorSetup.outputs.roleId
//   }
// }

// module keyvault 'keyvault/main.bicep' = {
//   name: 'keyvault-deployment'
//   scope: paxConnectExporterRg
//   params: {
//     location: location
//     appName: 'pe-${appSuffix}'
//     tenantId: tenantId
//   }
// }

// module cosmos 'cosmos-db/main.bicep' = {
//   name: 'cosmos-deployment'
//   scope: paxConnectExporterRg
//   params: {
//     cosmosAccountId: 'db-${appName}-${appSuffix}'
//     location: location
//     cosmosDbName: appName
//     keyVaultName: keyvault.outputs.keyVaultName
//   }
// }

// module azureFunctions_api 'function-app/main.bicep' = {
//   name: 'func-api-${appSuffix}'
//   scope: paxConnectExporterRg
//   params: {
//     appName: appName
//     location: location
//     appInternalServiceName: 'api-${appSuffix}'
//     // keyVaultName: keyvault.outputs.keyVaultName
//     msiRbacId: msi.outputs.id
//   }
//   dependsOn: [
//     // keyvault
//     msi
//     // cosmos
//   ]
// }

// module paxConnectExporter './paxconnect-exporter/main.bicep' = {
//   name: 'pax-connect-exporter'
//   scope: paxConnectExporterRg
//   params: {
//     prefix: prefix
//     location: location
//   }
// }
