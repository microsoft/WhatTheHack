# What The Hack - WVD

## Deploy the prerequisite templates

### PORTAL

#### Challenge 00

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FWhatTheHack%2Fmain%2Fchallenge-00.json)
[![Deploy to Azure Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FWhatTheHack%2Fmain%2Fchallenge-00.json)

#### Challenge 02

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FWhatTheHack%2Fmain%2Fchallenge-02.json)
[![Deploy to Azure Gov](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.svg?sanitize=true)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjamasten%2FWhatTheHack%2Fmain%2Fchallenge-02.json)

### POWERSHELL

```powershell
# Challenge 00
New-AzSubscriptionDeployment -Location 'eastus' -TemplateUri 'https://raw.githubusercontent.com/jamasten/WhatTheHack/main/challenge-00.json' -Verbose

# Challenge 02
New-AzSubscriptionDeployment -Location 'eastus' -TemplateUri 'https://raw.githubusercontent.com/jamasten/WhatTheHack/main/challenge-02.json' -Verbose
```

### AZURE CLI

```azurecli
# Challenge 00
az deployment sub create --location 'eastus' --template-uri 'https://raw.githubusercontent.com/jamasten/WhatTheHack/main/challenge-00.json' --verbose

# Challenge 02
az deployment sub create --location 'eastus' --template-uri 'https://raw.githubusercontent.com/jamasten/WhatTheHack/main/challenge-02.json' --verbose
```
