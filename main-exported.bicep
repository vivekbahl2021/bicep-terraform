param serverfarms_appsvcplbice101_name string
param sites_appsvceastusbcsp101_name string
param storageAccounts_staprepeus101_name string

resource storageAccounts_staprepeus101_name_resource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  kind: 'StorageV2'
  location: 'eastus'
  name: storageAccounts_staprepeus101_name
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    minimumTlsVersion: 'TLS1_0'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    supportsHttpsTrafficOnly: true
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource serverfarms_appsvcplbice101_name_resource 'Microsoft.Web/serverfarms@2022-09-01' = {
  kind: 'app'
  location: 'East US'
  name: serverfarms_appsvcplbice101_name
  properties: {
    elasticScaleEnabled: false
    hyperV: false
    isSpot: false
    isXenon: false
    maximumElasticWorkerCount: 1
    perSiteScaling: false
    reserved: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
  sku: {
    capacity: 0
    family: 'F'
    name: 'F1'
    size: 'F1'
    tier: 'Free'
  }
}

resource storageAccounts_staprepeus101_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccounts_staprepeus101_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_staprepeus101_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  parent: storageAccounts_staprepeus101_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    protocolSettings: {
      smb: {}
    }
    shareDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_staprepeus101_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  parent: storageAccounts_staprepeus101_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_staprepeus101_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
  parent: storageAccounts_staprepeus101_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_appsvceastusbcsp101_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  kind: 'app'
  location: 'East US'
  name: sites_appsvceastusbcsp101_name
  properties: {
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    containerSize: 0
    customDomainVerificationId: '965A0C98C2F03978748ECC70D9C9B49E25F7166376596DDE88901D0497B0D47B'
    dailyMemoryTimeQuota: 0
    enabled: true
    hostNameSslStates: [
      {
        hostType: 'Standard'
        name: '${sites_appsvceastusbcsp101_name}.azurewebsites.net'
        sslState: 'Disabled'
      }
      {
        hostType: 'Repository'
        name: '${sites_appsvceastusbcsp101_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
      }
    ]
    hostNamesDisabled: false
    httpsOnly: true
    hyperV: false
    isXenon: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    redundancyMode: 'None'
    reserved: false
    scmSiteAlsoStopped: false
    serverFarmId: serverfarms_appsvcplbice101_name_resource.id
    siteConfig: {
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      functionAppScaleLimit: 0
      http20Enabled: false
      minimumElasticInstanceCount: 0
      numberOfWorkers: 1
    }
    storageAccountRequired: false
    vnetContentShareEnabled: false
    vnetImagePullEnabled: false
    vnetRouteAllEnabled: false
  }
}

resource sites_appsvceastusbcsp101_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_appsvceastusbcsp101_name_resource
  location: 'East US'
  name: 'ftp'
  properties: {
    allow: true
  }
}

resource sites_appsvceastusbcsp101_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_appsvceastusbcsp101_name_resource
  location: 'East US'
  name: 'scm'
  properties: {
    allow: true
  }
}

resource sites_appsvceastusbcsp101_name_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: sites_appsvceastusbcsp101_name_resource
  location: 'East US'
  name: 'web'
  properties: {
    acrUseManagedIdentityCreds: false
    alwaysOn: false
    autoHealEnabled: false
    azureStorageAccounts: {}
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    detailedErrorLoggingEnabled: false
    elasticWebAppScaleLimit: 0
    experiments: {
      rampUpRules: []
    }
    ftpsState: 'FtpsOnly'
    functionsRuntimeScaleMonitoringEnabled: false
    http20Enabled: false
    httpLoggingEnabled: false
    ipSecurityRestrictions: [
      {
        action: 'Allow'
        description: 'Allow all access'
        ipAddress: 'Any'
        name: 'Allow all'
        priority: 2147483647
      }
    ]
    loadBalancing: 'LeastRequests'
    localMySqlEnabled: false
    logsDirectorySizeLimit: 35
    managedPipelineMode: 'Integrated'
    minTlsVersion: '1.2'
    minimumElasticInstanceCount: 0
    netFrameworkVersion: 'v4.0'
    numberOfWorkers: 1
    phpVersion: '5.6'
    preWarmedInstanceCount: 0
    publishingUsername: '$appsvceastusbcsp101'
    remoteDebuggingEnabled: false
    requestTracingEnabled: false
    scmIpSecurityRestrictions: [
      {
        action: 'Allow'
        description: 'Allow all access'
        ipAddress: 'Any'
        name: 'Allow all'
        priority: 2147483647
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    scmMinTlsVersion: '1.2'
    scmType: 'None'
    use32BitWorkerProcess: true
    virtualApplications: [
      {
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
        virtualPath: '/'
      }
    ]
    vnetPrivatePortsCount: 0
    vnetRouteAllEnabled: false
    webSocketsEnabled: false
  }
}

resource sites_appsvceastusbcsp101_name_sites_appsvceastusbcsp101_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: sites_appsvceastusbcsp101_name_resource
  location: 'East US'
  name: '${sites_appsvceastusbcsp101_name}.azurewebsites.net'
  properties: {
    hostNameType: 'Verified'
    siteName: 'appsvceastusbcsp101'
  }
}