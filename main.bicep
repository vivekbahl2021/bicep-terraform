param location string = resourceGroup().location
param namePrefix string = 'storage'

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
var storageAccountSku = 'Standard_RAGRS'

module stgModule './cosmosdb.bicep' = {
  name: 'cosmosDBDeploy'
  params: {
    location: location
  }
}

var appsrvcplan = 'appsvcplbice101'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appsrvcplan
  location: location
  sku:{
    name: 'F1'
  }
}
param appsvcname string = 'appsvceastusbcsp101'

resource appServiceApp'Microsoft.Web/sites@2022-03-01' = {
  name: appsvcname
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSku
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
