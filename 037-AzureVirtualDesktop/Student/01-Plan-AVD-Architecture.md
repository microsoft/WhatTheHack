# Challenge 1: Design the AVD Architecture

[Previous Challenge](./00-Pre-Reqs.md) - **[Home](../README.md)** - [Next Challenge>](./02-Implement-Manage-Network.md)

## Introduction

This Challenge is to design the AVD architecture that will be deployed in later challenges.  By the end of this session you should have a plan for the host pools, session hosts, profile storage and client deployment.  

You should also have considered all aspects of security in this design including GPO, identity, and RBAC.

## Description

Taking into account our scenario, specify the details for the following:

1. Host pool(s)  
1. Images
1. Storage  
1. Clients
1. Security  
1. Networking
1. FSLogix

## Success Criteria

- Created a document defining all of the parameters that will be used in the deployment challenges.  

## Tips

Have you designed with both the PoC and eventual size in mind?  Consider [Enterprise level deployment guidance](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop) and confirm if Azure limits are adhered to.
How might cost be balanced with capacity in a follow the sun model?

## Learning Resources

Here are some links that may help inform design decisions:

[Az-140 ep01 | Mgmt grp Subs Resource grp](https://www.youtube.com/watch?v=EG_Zqdm7OQ0&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=3)

[Az-140 ep02 | Configure Active Directory | Azure AD DNS](https://www.youtube.com/watch?v=kfOYWFpoglQ&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=4)

[Az-140 ep03 | Plan Windows Virtual Desktop Host Pool](https://www.youtube.com/watch?v=FLbcayyodqk&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=4)

[Az-140 ep04 | Plan Your AVD Session Hosts](https://www.youtube.com/watch?v=HNCZ2pzr9mo&list=PL-V4YVm6AmwW1DBM25pwWYd1Lxs84ILZT&index=6)

[AVD overview](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)

[Virtual Machine Sizing](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs)

[FSLogix](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)

[Remote Desktop Clients](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-clients)

[Security](https://docs.microsoft.com/en-us/azure/virtual-desktop/security-baseline)

[Role based access control](https://docs.microsoft.com/en-us/azure/virtual-desktop/rbac)
