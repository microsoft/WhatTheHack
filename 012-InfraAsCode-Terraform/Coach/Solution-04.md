# Challenge 4: Secret Values with Azure Key Vault - Coach's Guide

[< Previous Challenge](./Solution-03.md) - **[Home](./README.md)** - [Next Challenge >](./Solution-05.md)

## Notes & Guidance

This challenge, while conceptually straightforward, has a number of "gotchas" that can complicate getting it working.

+ Make sure you are using the latest version of the azurerm provider (eg >= 3.52.0). Earlier versions had problems with timing out when configuring the AKV.
+ The terraform access_policy definitions can be tricky to get working, especially if you are using cli auth.  I found that most online examples use `data "azurerm_client_config" "current" {}` to grab the tenant id and current user id; however, this failed for me.  I was able to get it working using `data "azuread_client_config" "current" {}`.  See the file `kv.tf` for a working solution.

