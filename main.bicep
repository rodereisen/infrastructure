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
var azureStaticWebAppName = 'black-pebble-0f29bd703.azurestaticapps.net'
var azureStaticWebResourceName == 'rodereisen-de'
// apexResourceId: '/subscriptions/9696009b-e3a7-4a9f-b9a4-70b155ec5b87/resourceGroups/rodereisen-de/providers/Microsoft.Web/staticSites/rodereisen-de'
// Setting target scope
targetScope = 'subscription' // a 4-char suffix to add to the various names of azure resources to help them be unique, but still, previsible

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

// Domains
resource domainsRg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-domains'
  location: location
}
module rodereisenDeDomain './domains/main.bicep' = {
  name: 'rodereisenDeDomain'
  scope: domainsRg
  params: {
    azureStaticWebAppName: azureStaticWebAppName
    azureStaticWebResourceName: azureStaticWebResourceName
    deployM365: true
    mscid: mscid
    domainName: 'rodereisen'
    topLevelDomainName: 'de'
  }
}
module reisebuerorodeDeDomain './domains/main.bicep' = {
  name: 'reisebuerorodeDeDomain'
  scope: domainsRg
  params: {
    azureStaticWebAppName: azureStaticWebAppName
    azureStaticWebResourceName: azureStaticWebResourceName
    deployM365: false
    mscid: mscid
    domainName: 'reisebuerorode'
    topLevelDomainName: 'de'
  }
}
module reisebrorodeDeDomain './domains/main.bicep' = {
  apexResourceId: '/subscriptions/9696009b-e3a7-4a9f-b9a4-70b155ec5b87/resourceGroups/rodereisen-de/providers/Microsoft.Web/staticSites/rodereisen-de'
  name: 'reisebrorodeDeDomain'
  scope: domainsRg
  params: {
    azureStaticWebAppName: azureStaticWebAppName
    azureStaticWebResourceName: azureStaticWebResourceName
    deployM365: false
    mscid: mscid
    domainName: 'xn--reisebrorode-ilb'
    topLevelDomainName: 'de'
  }
}

//// Paxconnect Exporter
// var salt = 5
// var appSuffix = substring(uniqueString('${paxConnectExporterRg.id}${salt}'), 0, 5)
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
