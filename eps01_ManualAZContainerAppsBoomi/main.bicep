targetScope = 'subscription'

// -------------------------------------
// Azure Parameters
// -------------------------------------

@secure()
@description('Subscription ID of the environment')
param subscriptionId string

@description('Name of the new Resource Group to create')
param rgName string

@description('Region where all resources will be deployed')
param location string

@description('Name of the new Container App to create')
param containerAppName string

@description('VNET name')
param vnetName string

@description('Container app subnet name')
param containerAppSubnetName string

@description('Storage Account subnet name')
param storageAccountSubnetName string

@description('Managed Environment name')
param managedEnvironmentName string

@description('Managed Environment name')
param logAnalyticsWorkspaceName string

@description('Storage Account name')
param storageAccountName string

@description('Subnet Resource ID for the Container App')
param containerAppSubnetResourceId string = '/subscriptions/${subscriptionId}/resourceGroups/${rgName}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${containerAppSubnetName}'

@description('Subnet Resource ID for the Storage Account')
param storageAccountSubnetResourceId string = '/subscriptions/${subscriptionId}/resourceGroups/${rgName}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${storageAccountSubnetName}'

// -------------------------------------
// Boomi Parameters
// -------------------------------------
@description('Boomi Atom Name')
param boomiAtomName string

@secure()
@description('Installer Token for Boomi, should be updated after each use')
param boomiInstallerToken string

@description('Boomi Version (e.g.,atom or molecule and then : release, release-rhel, 5.x.x)')
param boomiContainerVersion string

@description('Environment of Boomi')
param boomiEnvironmentId string

//------------------------------------
// Resource: Resource Group Creation
//------------------------------------
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: rgName
}

// ------------------------------------
// Resource: Virtual Network (AVM Module)
// ------------------------------------
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: vnetName
  scope: resourceGroup
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/22'
      'fd00:592b:3014::/64'
    ]
    name: vnetName
    // Non-required parameters
    location: location
    subnets: [
      {
        addressPrefixes: [
          '10.0.0.0/23' // Subnet for Container App
        ]
        name: containerAppSubnetName
      }
      {
        addressPrefixes: [
          '10.0.2.0/23' // Subnet for Storage Account
        ]
        name: storageAccountSubnetName
      }
    ]
  }
}

// ------------------------------------
// Resource: Azure Storage Account with NFS
// ------------------------------------
module storageAccount 'br/public:avm/res/storage/storage-account:0.15.0' = {
  name: storageAccountName
  scope: resourceGroup
  params: {
    // Required parameters
    name: storageAccountName
    // Non-required parameters
    fileServices: {
      shares: [
        {
          enabledProtocols: 'NFS'
          name: 'nfsstorageboomi'
        }
      ]
    }
    kind: 'FileStorage'
    location: location
    skuName: 'Premium_LRS'
    managedIdentities: {
      systemAssigned: true
    }
    privateEndpoints: [
      {
        service: 'file'
        subnetResourceId: storageAccountSubnetResourceId
      }
    ]
  }
  dependsOn: [virtualNetwork]
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: logAnalyticsWorkspaceName
  scope: resourceGroup
  params: {
    // Required parameters
    name: logAnalyticsWorkspaceName
    // Non-required parameters
    location: location
  }
  dependsOn: [virtualNetwork]
}
// ------------------------------------
// Resource: Container App Environment
// ------------------------------------
module managedEnvironment 'br/public:avm/res/app/managed-environment:0.8.1' = {
  name: managedEnvironmentName
  scope: resourceGroup
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    name: managedEnvironmentName
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: resourceGroup.name
    infrastructureSubnetId: containerAppSubnetResourceId
    internal: true
    location: location
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    zoneRedundant: false
    storages: [
      {
        kind: 'NFS'
        storageAccountName: storageAccountName
        accessMode: 'ReadWrite'
        shareName: 'nfsstorageboomi'
      }
    ]
  }
}

// ------------------------------------
// Module: Boomi Container App (AVM Module)
// ------------------------------------
module containerApp 'br/public:avm/res/app/container-app:0.11.0' = {
  name: containerAppName
  scope: resourceGroup
  params: {
    containers: [
      {
        image: 'docker.io/boomi/${boomiContainerVersion}'
        name: containerAppName
        resources: {
          cpu: '1'
          memory: '2Gi'
        }
        env: [
          {
            name: 'INSTALL_TOKEN'
            secretRef: 'secrboomitoken'
          }
          {
            name: 'BOOMI_ATOMNAME'
            value: boomiAtomName
          }
          {
            name: 'ATOM_LOCALHOSTID'
            value: boomiAtomName
          }
          {
            name: 'name'
            value: boomiAtomName
          }
          {
            name: 'BOOMI_ENVIRONMENTID'
            value: boomiEnvironmentId
          }
        ]
        probes: []
      }
    ]
    environmentResourceId: managedEnvironment.outputs.resourceId
    name: containerAppName
    ingressAllowInsecure: false
    ingressExternal: false
    ingressTargetPort: 9090
    ingressTransport: 'tcp'
    location: location
    volumes: [
      {
        name: 'boomi-storage'
        storageType: 'NfsAzureFile'
        storageName: 'nfsstorageboomi'
      }
    ]
    secrets: {
      secureList: [
        {
          name: 'secrboomitoken'
          value: boomiInstallerToken
        }
      ]
    }
    scaleMinReplicas: 1 // Increase this one if you use a Molecule
    scaleMaxReplicas: 1 // Increase this one if you use a Molecule
  }
}
