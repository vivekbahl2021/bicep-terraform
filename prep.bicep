param location string = 'eastus'
param storageAccountName string = 'staprepeus101${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

var appServicePlanName = 'toy-product-launch-plan'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01'= {
  name: 'staprepeus101'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties:{ 
    accessTier: 'Hot'
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

