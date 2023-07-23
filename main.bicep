param location string = resourceGroup().location
//param namePrefix string = 'storage'

// var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
// var storageAccountSku = 'Standard_RAGRS'

module stgModule './cosmosdb.bicep' = {
  name: 'cosmosDBDeploy'
  params: {
    location: location
  }
}

module funcAppModule './funcapp.bicep' = {
  name: 'functionAppDeploy'
  params: {
    location: location
    appInsightsLocation: location
    cosmosDBAccountName: stgModule.outputs.dbAccountName
    cosmosDBAccountId: stgModule.outputs.dbAccountId
    cosmosDBApiVersion: stgModule.outputs.dbApiVersion
  }
}

// resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
//   name: storageAccountName
//   location: location
//   kind: 'StorageV2'
//   sku: {
//     name: storageAccountSku
//   }
//   properties: {
//     accessTier: 'Hot'
//     supportsHttpsTrafficOnly: true
//   }
// }

// output storageAccountId string = storageAccount.id
