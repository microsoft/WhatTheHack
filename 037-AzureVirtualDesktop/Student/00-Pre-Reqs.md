# Challenge 0: Getting started

**[Home](../README.md)** - [Next Challenge>](./01-Plan-AVD-Architecture.md)

## Introduction

This challenge is to ensure that all the pre-requisites and/or concepts to start the planning and deployment for Azure Virtual Desktop (AVD) are in place.

## Description

Thinking about the pre-reqs needed for Azure Virtual Desktop. Be ready to explain the pre-reqs and/or concepts needed for a succesful deployment.

1. At least one Student should have Global Admin rights to the Tenant and Owner rights to the subscription.
1. Other students need a minimum of Contributor access on the subscription.
1. M365 Licenses should be assigned to the test users.

### Deploy Resource Groups

#### POWERSHELL

```powershell
New-AzSubscriptionDeployment -Location 'eastus' -TemplateUri 'https://raw.githubusercontent.com/microsoft/WhatTheHack/master/037-AzureVirtualDesktop/Student/Resources/challenge-00_Template.json' -Verbose
```

#### AZURE CLI

```shell
az deployment sub create --location 'eastus' --template-uri 'https://raw.githubusercontent.com/microsoft/WhatTheHack/master/037-AzureVirtualDesktop/Student/Resources/challenge-00_Template.json' --verbose
```

## Success Criteria

1. Users are assigned to the correct roles
1. Licenses are assigned to the users.

**NOTE:** Identity will be used for many aspects - permissions and assignments for example, remember to think about this.

## Learning Resources

[What is Azure Virtual Desktop?](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)

[Az-140 ep01 | Mgmt grp Subs Resource grp](https://www.youtube.com/watch?v=EG_Zqdm7OQ0&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=3)

[Az-140 ep02 | Configure Active Directory | Azure AD DNS](https://www.youtube.com/watch?v=kfOYWFpoglQ&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=4)

[Az-140 ep05 | AVD Network Planning](https://www.youtube.com/watch?v=O3AaPTWzpi4&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=6)

[Az-140 ep06 | Plan AVD License](https://www.youtube.com/watch?v=oV3-w88lIu4&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=7)
