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
var salt = '1'
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
param appName string = 'paxconnect-exporter'
param tenantId string = tenant().tenantId

param paxLocation string = 'swedencentral'

resource paxConnectExporterRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-paxconnect-exporter-${salt}'
  location: paxLocation
}

module operatorSetup 'operator-setup/main.bicep' = {
  name: 'operatorSetup-deployment'
  scope: paxConnectExporterRg
  params: {
    operatorPrincipalId: deploymentOperatorId
    appName: appName
  }
}

module msi 'msi/main.bicep' = {
  name: 'msi-deployment'
  scope: paxConnectExporterRg
  params: {
    location: paxLocation
    managedIdentityName: '${prefix}Identity'
    operatorRoleDefinitionId: operatorSetup.outputs.roleId
  }
}

module keyvault 'keyvault/main.bicep' = {
  name: 'keyvault-deployment'
  scope: paxConnectExporterRg
  params: {
    location: paxLocation
    appName: 'pe-${appSuffix}'
    tenantId: tenantId
  }
}

module cosmos 'cosmos-db/main.bicep' = {
  name: 'cosmos-deployment'
  scope: paxConnectExporterRg
  params: {
    cosmosAccountId: '${appName}-db'
    location: paxLocation
    cosmosDbName: appName
    keyVaultName: keyvault.outputs.keyVaultName
  }
}

module azureFunctions_api 'function-app/main.bicep' = {
  name: 'func-api'
  scope: paxConnectExporterRg
  params: {
    appName: appName
    location: paxLocation
    appInternalServiceName: 'api'
    keyVaultName: keyvault.outputs.keyVaultName
    msiRbacId: msi.outputs.id
  }
  dependsOn: [
    keyvault
    msi
    cosmos
  ]
}

// module paxConnectExporter './paxconnect-exporter/main.bicep' = {
//   name: 'pax-connect-exporter'
//   scope: paxConnectExporterRg
//   params: {
//     prefix: prefix
//     location: paxLocation
//   }
// }
