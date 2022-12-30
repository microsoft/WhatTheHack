param location string = resourceGroup().location
@description('This is the domain name you registered for--for example: wthlab.dynv6.com')
param rfc2136ZoneName string
@description('This is the name of the TSIG key you created for your domain; it should start with \'tsig-\'')
param rfc2136TSIGKeyName string
@description('This is the name of the DNS server which accepts RFC2136 updates; for example: \'ns1.dynv6.com\'')
param rfc2136DNSNameserver string = 'ns1.dynv6.com'
param rfc2136KeyAlgorithm string = 'hmac-sha256'
@secure()
param rfc2136TSIGSecret string
@description('Email address where Let\'s Encrypt will send alerts if there are issues with the certificate or it expires. This must be a valid email address and will receive alerts from Let\'s Encrypt, which can be ignored if you\'re no longer running the lab environment.')
param letsEncryptCertAlertEmail string
@description('Alternative to using Let\'s Encrypt, you can use a self-signed certificate. This is useful if you are having issues with the Let\'s Encrypt certificate request process. NOTE: You will still need a domain domain name registered for the lab environment.')
param useSelfSignedCertificate bool = false

var dnsUpdaterContainerImage = 'mbrat2005/whatthehackdnsupdate:latest'

resource wthlaw 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: 'wth-law-default01'
}

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'wth${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    enableSoftDelete: true
    enablePurgeProtection: true
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        objectId: userAssignedIdentity.properties.principalId
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: 'wth-pip-appgw01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'wth-umsi-certrequester01'
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'wthcertreq${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
  resource fileSvc 'fileServices@2022-09-01' = {
    name: 'default'

    resource fileshare 'shares@2022-09-01' = {
      name: 'lego'
      properties: {
      }
    }
  }
}

//grant user identity permissions to read storage account resource
resource roleAssignmentUMIReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userAssignedIdentity.id, storageAccount.id, 'Reader and Data Access')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c12c1c16-33a1-487b-954d-41c89c60f349') // Reader and Data Access
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// grant user identity permissions to read storage account data
resource roleAssignmentUMIStorageData 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userAssignedIdentity.id, storageAccount.id, 'data')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb') // Storage File Data SMB Share Contributor
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// grant user identity permissions to key vault
resource roleAssignmentUMIKeyVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userAssignedIdentity.id, keyvault.id)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483') // Key Vault Admin
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// grant user identity to key vault via access policy
resource accessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: '${keyvault.name}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: tenant().tenantId
        objectId: userAssignedIdentity.properties.principalId
        permissions: {
          secrets: [
            'all'
          ]
          keys: [
            'all'
          ]
          certificates: [
            'all'
          ]
        }
      }
    ]
  }
}

// using the work of the lego project (https://go-acme.github.io/lego/), requests a publicly trusted certificate from letsencrypt
// the letsencrypt certificate challenge is performed via DNS, so we need to update the DNS record for the domain. 
// this was tested with dynv6.com, but should work with any DNS provider that supports RFC2136
// stores the certificate in the mounted storage account file share
resource containerCertRequester 'Microsoft.ContainerInstance/containerGroups@2022-09-01' = if (useSelfSignedCertificate == false) {
  name: 'wth-container-certrequester01'
  location: location
  dependsOn: [
    roleAssignmentUMIReader
    roleAssignmentUMIStorageData
    roleAssignmentUMIKeyVault
  ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    containers: [
      {
        name: 'wth-container-certrequester01'
        properties: {
          image: 'goacme/lego:latest'
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          command: [
            'lego'
            '--domains'
            rfc2136ZoneName
            '-m'
            letsEncryptCertAlertEmail
            '--dns'
            'rfc2136'
            '-a'
            '--pfx'
            '--path'
            '/lego'
            //'--server=https://acme-staging-v02.api.letsencrypt.org/directory'  // ust staging environment for testing to avoid rate limits
            'run'
          ]
          environmentVariables: [
            {
              name: 'RFC2136_NAMESERVER'
              value: rfc2136DNSNameserver
            }
            {
              name: 'RFC2136_TSIG_KEY'
              value: rfc2136TSIGKeyName
            }
            {
              name: 'RFC2136_TSIG_ALGORITHM'
              value: rfc2136KeyAlgorithm
            }
            {
              name: 'RFC2136_TSIG_SECRET'
              secureValue: rfc2136TSIGSecret
            }
          ]
          volumeMounts: [
            {
              name: 'lego'
              mountPath: '/lego'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    volumes: [
      {
        name: 'lego'
        azureFile: {
          shareName: storageAccount::fileSvc::fileshare.name
          storageAccountName: storageAccount.name
          storageAccountKey: storageAccount.listKeys().keys[0].value
        }
      }
    ]
    restartPolicy: 'Never'
    sku: 'Standard'
    diagnostics: {
      logAnalytics: {
        workspaceId: wthlaw.properties.customerId
        workspaceKey: listKeys(wthlaw.id, wthlaw.apiVersion).primarySharedKey
      }
    }
  }
}

// updates the DNS zone with an A record for the Application Gateway's public IP address
// uses 'nsupdate' in a custom container image referenced in this variable: dnsUpdaterContainerImage
// the container image is built from the Dockerfile in the 'docker' folder of this repo
// this was tested with dynv6.com, but should work with any DNS provider that supports RFC2136
resource containerDNSUpdater 'Microsoft.ContainerInstance/containerGroups@2022-09-01' = {
  name: 'wth-container-dnsupdater01'
  location: location
  dependsOn: [
    containerCertRequester
  ]
  properties: {
    containers: [
      {
        name: 'wth-container-dnsupdater01'
        properties: {
          image: dnsUpdaterContainerImage
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          command: []
          environmentVariables: [
            {
              name: 'ZONENAME'
              value: rfc2136ZoneName
            }
            {
              name: 'KEYNAME'
              value: rfc2136TSIGKeyName
            }
            {
              name: 'KEYALGORITHM'
              value: rfc2136KeyAlgorithm
            }
            {
              name: 'KEYVALUE'
              secureValue: rfc2136TSIGSecret
            }
            {
              name: 'APPGWPUBLICIP'
              value: publicIP.properties.ipAddress
            }
            {
              name: 'NAMESERVER'
              value: rfc2136DNSNameserver 
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: 'Never'
    sku: 'Standard'
    diagnostics: {
      logAnalytics: {
        workspaceId: wthlaw.properties.customerId
        workspaceKey: listKeys(wthlaw.id, wthlaw.apiVersion).primarySharedKey
      }
    }
  }
} 

// uploads the certificate previously exported to the storage account file share to the key vault
// from the key vault, the certificate will be available to the Application Gateway 
resource deploymentScriptCertUploader 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (useSelfSignedCertificate == false) {
  name: 'wth-dscript-uploadcert01'
  location: location
  dependsOn: [
    containerCertRequester
  ]
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.3'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
    arguments: '-resourceGroup "${resourceGroup().name}" -storageAccountName "${storageAccount.name}" -keyVaultName "${keyvault.name}" -shareName "${storageAccount::fileSvc::fileshare.name}"'
    scriptContent: '''
      param($resourceGroup, $storageAccountName, $keyVaultName, $shareName)

      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['text'] = ''

      $context = (Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup).context
      $directory = Get-AzStorageFile -ShareName $shareName -Path 'certificates' -Context $context
      $pfxFile = $directory.CloudFileDirectory.ListFilesAndDirectories() | Where-Object { $_.Name -like '*.pfx' }

      If ($pfxFile) {
        $pfxFile.DownloadToFile('/cert.pfx','CreateNew')
      }
      Else {
        throw 'No certificate file found in the storage account file share--check the certificate requester "wth-container-certrequester01" container logs for errors.'
      }

      $cert = Import-AzKeyVaultCertificate -Name appGWCert -VaultName $keyVaultName -FilePath '/cert.pfx' -Password (ConvertTo-SecureString -Force -AsPlainText 'changeit')

      $DeploymentScriptOutputs['text'] = $cert.SecretId
    '''
  containerSettings: {
    containerGroupName: 'wth-container-certuploader01'
    }
  }
}

resource deploymentScriptSelfSignedCert 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (useSelfSignedCertificate) {
name: 'wth-dscript-genselfsignedcert01'
location: location
dependsOn: [
  roleAssignmentUMIReader
  roleAssignmentUMIStorageData
  roleAssignmentUMIKeyVault
]
kind: 'AzurePowerShell'
identity: {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${userAssignedIdentity.id}': {}
  }
}
properties: {
  azPowerShellVersion: '8.3'
  cleanupPreference: 'OnSuccess'
  retentionInterval: 'PT1H'
  arguments: '-keyVaultName "${keyvault.name}" -domainName "${rfc2136ZoneName}"'
  scriptContent: '''
    param($keyVaultName, $domainName)

    $DeploymentScriptOutputs = @{}
    $DeploymentScriptOutputs['text'] = ''

    $body = @"
    {
      "policy": {
        "key_props": {
          "exportable": true,
          "kty": "RSA",
          "key_size": 2048,
          "reuse_key": false
        },
        "secret_props": {
          "contentType": "application/x-pkcs12"
        },
        "x509_props": {
          "subject": "CN=$domainName",
          "sans": {
            "dns_names": [
              "$domainName"
            ]
          }
        },
        "issuer": {
          "name": "Self"
        }
      }
    }
"@

    # create a certificate request in the key vault
    $certName = 'appGWSelfSignedCert' + (get-date -f 'yyyyMMddHHmmss')
    $response = Invoke-AzRestMethod -Method POST -URI "https://$keyVaultName.vault.azure.net//certificates/$certName/create?api-version=7.3" -Payload $body

    $responseBody = $response.Content | ConvertFrom-Json -Depth 10
    If ($response.StatusCode -ne 202) {
      throw "Error creating self-signed certificate in key vault. $($response.StatusCode, $responseBody.Error, $responseBody.status, $responseBody.status_details)"
    }

    # wait for the certificate request to complete
    $timeout = 600
    $secondsElapsed = 0
    do {
      $secondsElapsed = $secondsElapsed + 1
      $response = Invoke-AzRestMethod -Method GET -URI "https://$keyVaultName.vault.azure.net//certificates/$certName/pending?api-version=7.3"

      If ($response.StatusCode -ne 200) {
        $responseBody = $response.Content | ConvertFrom-Json -Depth 10
        throw "Error getting self-signed certificate status in key vault. $($response.StatusCode, $responseBody.Error,$responseBody.status, $responseBody.status_details)"
      }

      Start-Sleep -Seconds 1
    }
    until (($responseBody = $response.Content | ConvertFrom-Json -Depth 10).status -eq 'completed' -or ($secondsElapsed -ge $timeout))

    If ($secondsElapsed -ge $timeout) {
      throw "Timeout waiting for self-signed certificate to complete in key vault."
    }

    # get the completed certificate ID
    $response = Invoke-AzRestMethod -Method GET -URI "https://$keyVaultName.vault.azure.net//certificates/$certName`?api-version=7.3"
    $responseBody = $response.Content | ConvertFrom-Json -Depth 10

    # return the completed certificate ID to the deployment script output
    $DeploymentScriptOutputs['text'] = $responseBody.sid
  '''
containerSettings: {
  containerGroupName: 'wth-container-genselfsignedcert01'
  }
}
}

output TLSCertKeyVaultSecretID string = useSelfSignedCertificate ? reference(deploymentScriptSelfSignedCert.id, '2020-10-01').outputs.text : reference(deploymentScriptCertUploader.id, '2020-10-01').outputs.text
