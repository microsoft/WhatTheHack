# Challenge 08 - Azure Key Vault Integration - Coach's Guide 

[< Previous Solution](./Solution-07.md) - **[Home](./README.md)** - [Next Solution >](./Solution-09.md)

## Notes & Guidance


- To see all operators installed use `oc get subs -n openshift-operators` and Azure should show up
- To see all operators installed in the web console, go to `Operators installed`
- 


- Create a key vault using the Azure Service Operator
1) Create a SP
2) Create a namespace called `operators`
2) Create a secret
3) Install Azure Service Operator
4) Install Key Vault
5) Add Key
6) Reference Key