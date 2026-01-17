//provision a storage account
@description('Generated from RG:CRC-main-RG storage account')
resource storage_account 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  name: 'crcmainxrg1765444963'
  location: 'australiaeast'
  tags: {}
  properties: {
    allowCrossTenantDelegationSas: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
    // customDomain: {
    //   name: 'www.weirdcloud.dev'
    // }
  }
}




//provision a cosmos db account for the table storage
@description('Generated from RG: CRC-main-RG/providers/Microsoft.DocumentDB/databaseAccounts/weirdcloud-cosmos-db')
resource weirdcloudcosmosdb 'Microsoft.DocumentDB/databaseAccounts@2025-11-01-preview' = {
  name: 'weirdcloud-cosmos-db'
  location: 'Australia East'
  kind: 'GlobalDocumentDB'
  tags: {
    defaultExperience: 'Azure Table'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    //not needed for single region, however free to leave in
    enableAutomaticFailover: true
    enableMultipleWriteLocations: false
    enablePartitionKeyMonitor: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    EnabledApiTypes: 'Table, Sql'
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    capacityMode: 'Serverless'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    enablePerRegionPerPartitionAutoscale: false
    enableBurstCapacity: false
    enablePriorityBasedExecution: false
    defaultPriorityLevel: 'High'
    minimalTlsVersion: 'Tls12'
    enablePerPartitionAutomaticFailover: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 86400
      maxStalenessPrefix: 1000000
    }
    locations: [
      {
        locationName: 'Australia East'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableTable'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        // the cost is doubled for geo vs local redundancy
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    diagnosticLogSettings: {
      enableFullTextQuery: 'None'
    }
    capacity: {
      totalThroughputLimit: 4000
    }
  }
  identity: {
    type: 'None'
  }
}



//provision a function app
@description('Generated from RG:crc-main-rg/providers/Microsoft.Web/sites/weirdcloud-db-counter-api')
resource weirdclouddbcounterapi 'Microsoft.Web/sites@2025-03-01' = {
  name: 'weirdcloud-db-counter-api'
  kind: 'functionapp,linux'
  location: 'Australia East'
  tags: {
    //links to Application Insights
    'hidden-link:${resourceId('microsoft.insights/components', 'weirdcloud-db-counter-api')}': 'Resource'
  }
  properties: {
    name: 'weirdcloud-db-counter-api'
    webSpace: 'flex-0f76a6c46feff404b19d9b6e1a8cc1c114e48aecd372e6e4f2fabba10bae3fef-webspace'
    enabled: true
    adminEnabled: true
    siteScopedCertificatesEnabled: true
    afdEnabled: false
    csrs: []
    serverFarmId: '/subscriptions/bcd4fe40-938d-48e2-bea9-6425a552c4ab/resourceGroups/CRC-main-RG/providers/Microsoft.Web/serverfarms/ASP-CRCmainRG-9741'
    reserved: true
    isXenon: false
    hyperV: false
    storageRecoveryDefaultState: 'Running'
    contentAvailabilityState: 'Normal'
    runtimeAvailabilityState: 'Normal'
    dnsConfiguration: {}
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
      backupRestoreTraffic: false
      managedIdentityTraffic: false
    }
    siteConfig: {
      linuxFxVersion: ''
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 100
      minimumElasticInstanceCount: 0
      clusteringEnabled: false
      webJobsEnabled: false
      // ADD APPLICATION INSIGHTS INSTRUMENTATION KEY HERE
      // appSettings: [
      //   {name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
      //     value: appInsights.properties.ConnectionString 
      //   }]
    }
    functionAppConfig: {
      deployment: {
        storage: {
          type: 'blobcontainer'
          value: 'https://crcmainxrg1765444963.blob.core.windows.net/app-package-weirdcloud-db-counter-api-e618b87'
          authentication: {
            type: 'storageaccountconnectionstring'
            storageAccountConnectionStringName: 'DEPLOYMENT_STORAGE_CONNECTION_STRING'
          }
        }
      }
      runtime: {
        name: 'python'
        version: '3.13'
      }
      scaleAndConcurrency: {
        maximumInstanceCount: 100
        instanceMemoryMB: 512
      }
      siteUpdateStrategy: {
        type: 'Recreate'
      }
    }
    deploymentId: 'weirdcloud-db-counter-api'
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientAffinityProxyEnabled: false
    useQueryStringAffinity: false
    blockPathTraversal: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    kind: 'functionapp,linux'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    siteDisabledReason: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    functionsRuntimeAdminIsolationEnabled: false
    //On the Consumption plan, you don't have "Zone Redundancy"
    redundancyMode: 'None'
    privateEndpointConnections: []
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
  }
}
//provision an app service plan for the function app
@description('Generated from RG: CRC-main-RG/providers/Microsoft.Web/serverFarms/ASP-CRCmainRG-9741')
resource ASPCRCmainRG 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: 'ASP-CRCmainRG-9741'
  kind: 'functionapp'
  location: 'Australia East'
  properties: {
    serverFarmId: 33549
    name: 'ASP-CRCmainRG-9741'
    workerSize: 'Small'
    workerSizeId: 0
    currentWorkerSize: 'Small'
    currentWorkerSizeId: 0
    currentNumberOfWorkers: 0
    webSpace: 'flex-0f76a6c46feff404b19d9b6e1a8cc1c114e48aecd372e6e4f2fabba10bae3fef-webspace'
    planName: 'VirtualDedicatedPlan'
    computeMode: 'Dynamic'
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    kind: 'functionapp'
    reserved: true
    isXenon: false
    hyperV: false
    mdmId: 'waws-prod-sy3-111_33549'
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    maximumNumberOfZones: 3
    currentNumberOfZonesUtilized: 0
    vnetConnectionsUsed: 0
    vnetConnectionsMax: 2
    createdTime: '2025-12-27T08:01:31.0033333'
    asyncScalingEnabled: false
    isCustomMode: false
    powerState: 'Running'
    eligibleLogCategories: ''
  }
  sku: {
    name: 'FC1'
    tier: 'FlexConsumption'
    size: 'FC1'
    family: 'FC'
    capacity: 0
  }
}
//provision an application insights for the function app
@description('Generated from RG: CRC-main-RG/providers/microsoft.insights/components/weirdcloud-db-counter-api')
resource weirdclouddbcounterapi_2 'Microsoft.Insights/components@2020-02-02' = {
  kind: 'web'
  name: 'weirdcloud-db-counter-api'
  location: 'australiaeast'
  tags: {}
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaWebAppExtensionCreate'
    RetentionInDays: 90
    /*change this string for new provison, update the WorkspaceResourceId to the new Log Analytics workspace */
    WorkspaceResourceId: '/subscriptions/bcd4fe40-938d-48e2-bea9-6425a552c4ab/resourceGroups/DefaultResourceGroup-EAU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-bcd4fe40-938d-48e2-bea9-6425a552c4ab-EAU'
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    DisableLocalAuth: false
    Ver: 'v2'
  }
}
