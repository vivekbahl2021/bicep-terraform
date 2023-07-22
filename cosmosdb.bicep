@description('Azure Cosmos DB account name, max length 44 characters')
param accountName string = 'sql-${uniqueString(resourceGroup().id)}'

@description('Location for the Azure Cosmos DB account.')
param location string = resourceGroup().location

@description('The primary region for the Azure Cosmos DB account.')
param primaryRegion string = location

//@description('The secondary region for the Azure Cosmos DB account.')
//param secondaryRegion string

@allowed([
  'Eventual'
  'ConsistentPrefix'
  'Session'
  'BoundedStaleness'
  'Strong'
])
@description('The default consistency level of the Cosmos DB account.')
param defaultConsistencyLevel string = 'Session'

@minValue(10)
@maxValue(2147483647)
@description('Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.')
param maxStalenessPrefix int = 100000

@minValue(5)
@maxValue(86400)
@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
param maxIntervalInSeconds int = 300

@allowed([
  true
  false
])
@description('Enable system managed failover for regions')
param systemManagedFailover bool = false

@description('The name for the database')
param databaseName string = 'dataForFunctionApps'

@description('The name for the container')
param containerName string = 'customerData'

@minValue(400)
@maxValue(1000000)
@description('The throughput for the container')
param throughput int = 400

var consistencyPolicy = {
  Eventual: {
    defaultConsistencyLevel: 'Eventual'
  }
  ConsistentPrefix: {
    defaultConsistencyLevel: 'ConsistentPrefix'
  }
  Session: {
    defaultConsistencyLevel: 'Session'
  }
  BoundedStaleness: {
    defaultConsistencyLevel: 'BoundedStaleness'
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
  }
  Strong: {
    defaultConsistencyLevel: 'Strong'
  }
}
var locations = [
  {
    locationName: primaryRegion
    failoverPriority: 0
    isZoneRedundant: false
  }
]
var capabilities = [
  {
    name: 'EnableServerless'
  }
]
var capacity =   {
    totalThroughputLimit: 4000
  }


resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: toLower(accountName)
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    capabilities: capabilities
    capacity: capacity
    publicNetworkAccess: 'Enabled'

  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  name: '${account.name}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  name: '${database.name}/${containerName}'
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
        version: 2
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          // {
          //   path: '/myPathToNotIndex/*'
          // }
          {
            path: '/_etag/?'
          }
        ]
        // compositeIndexes: [
        //   [
        //     // {
        //     //   path: '/name'
        //     //   order: 'ascending'
        //     // }
        //     // {
        //     //   path: '/age'
        //     //   order: 'descending'
        //     // }
        //   ]
        // ]
        // spatialIndexes: [
        //   {
        //     path: '/location/*'
        //     types: [
        //       'Point'
        //       'Polygon'
        //       'MultiPolygon'
        //       'LineString'
        //     ]
        //   }
        // ]
      }
      // defaultTtl: 86400
      uniqueKeyPolicy: {
        uniqueKeys: [
          // {
          //   paths: [
          //     '/phoneNumber'
          //   ]
          // }
        ]
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
    // options: {
    //   throughput: throughput
    // }
  }
}
