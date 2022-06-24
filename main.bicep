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

@description('This is the object id of the user who will do the deployment on Azure. Can be your user id on AAD. Discover it running [az ad signed-in-user show] and get the [objectId] property.')
param deploymentOperatorId string

// Variables
var azureStaticWebAppName = 'black-pebble-0f29bd703.azurestaticapps.net'
var ipv4 = '5.175.14.35'
var ipv6 = '2a01:488:42:1000:50ed:8223:e6:9d2e'

// Setting target scope
targetScope = 'subscription'

// Resources

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
param appName string = 'paxConnectExporter'
param tenantId string = tenant().tenantId

resource paxConnectExporterRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-paxconnect-exporter'
  location: location
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
    location: location
    managedIdentityName: '${prefix}Identity'
    operatorRoleDefinitionId: operatorSetup.outputs.roleId
  }
}

// creates a key vault in this resource group
module keyvault 'keyvault/main.bicep' = {
  name: 'keyvault-deployment'
  scope: paxConnectExporterRg
  params: {
    location: location
    appName: appName
    tenantId: tenantId
  }
}

module cosmos 'cosmos-db/main.bicep' = {
  name: 'cosmos-deployment'
  scope: paxConnectExporterRg
  params: {
    cosmosAccountId: '${appName}-db'
    location: location
    cosmosDbName: appName
    keyVaultName: keyvault.outputs.keyVaultName
  }
}

// creates an azure function, with secrets stored in the key vault
// module azureFunctions_api 'function-app/main.bicep' = {
//   name: 'functions-app-deployment-api'
//   scope: paxConnectExporterRg
//   params: {
//     appName: appName
//     appInternalServiceName: 'api'
//     appNameSuffix: appSuffix
//     appInsightsInstrumentationKey: logAnalytics.outputs.instrumentationKey
//     keyVaultName: keyvault.outputs.keyVaultName
//     msiRbacId: msi.outputs.id
//   }
//   dependsOn: [
//     keyvault
//     paxConnectExporter
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
