# Challenge 7: Replication

[< Previous Challenge](./06-private-endpoint.md) - **[Home](./README.md)** 

## Coach Tips

* After they complete this one, remind the attendee to delete the replica since it will increase billing while it is running. 
* If the attendee has extra time, consider challenging them with doing a database failover where they stop the replication and configuring the application to use the replica instead. 
* If the attendee wants to keep the AKS cluster running for some time and also save cost, they can stop the VMSS nodes and restart them later. The nodes are under the MC_*** resource group and there is a script to [stop the VMSS nodes](../Student/Resources/HelmCharts/ContosoPizza/stop_vmss_node.sh)
