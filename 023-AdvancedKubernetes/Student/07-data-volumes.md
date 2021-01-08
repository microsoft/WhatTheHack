# Challenge 7 - Data Volumes

[< Previous Challenge](./06-service-mesh.md)

## Introduction

When working with cloud native applications, the ideal location for persisting data is in SaaS Database service or object/blob storage.  However, that isn't always possible, and some applications need to access local file storage.  Kubernetes uses Persistent Volumes and Persistent Volume Claims to manage volumes mounted inside running containers.

A Kubernetes persistent volume represents storage that has been provisioned for use with Kubernetes pods. A persistent volume can be used by one or many pods, and can be dynamically or statically provisioned.

Persistent Volumes have different [Access Modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) which define how they can be utilitzed.  
* ReadWriteOnce -- the volume can be mounted as read-write by a single node (e.g. Azure Disk)
* ReadOnlyMany -- the volume can be mounted read-only by many nodes (e.g. Azure Files, NFS, SMB)
* ReadWriteMany -- the volume can be mounted as read-write by many nodes (e.g. Azure Files, NFS, SMB)

The storage solution options for AKS are:

* [Azure Managed Disk](https://docs.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview) - Standard Azure disk (ReadWriteOnce)
* [Azure Files](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction) - Supports SMB or [NFS](https://en.wikipedia.org/wiki/Network_File_System) protocol (ReadWriteMany, ReadWriteOnce)
* [Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction) - Supports NFS protocol (ReadWriteMany, ReadWriteOnce)
* Bring your own NFS Server

The Kubernetes concepts for storage are:
* [Storage Class](https://kubernetes.io/docs/concepts/storage/storage-classes/) (SC) - Describes the "profile" of the storage solution.  (e.g. Azure Disk with LRS)
* [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) (PV) - A storage instance (e.g. A specific Azure Disk resource)
* [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) (PVC) - A request for a storage instance (e.g. Request for a 30Gi disk with a Storage Class).  When this request is fulfilled, it will create a Persistent Volume.



## Success Criteria

This challenge has multiple, independent sub-challenges.  Complete each of them to complete the Data Volumes challenge.

In the first sub-challenge you will deploy the sample pod using Azure Disk as a PVC, verify that it works and kill the pod and kill the node to see the impact.  

In the subsequent sub-challanges, you will deploy new pods with different scenarios (e.g. Azure Files with NFS as a PVC; Azure Disk using an existing disk as a PV; etc.) and perform the same verification, killing the pod and then killing the node.

The architecture for the sample pod is:
* 1 pod with 2 containers
  * busybox-writer: every 1 second, will append the current timestamp to /mnt/index.html.  This simulates an application writing data to a local filesystem.
  * busybox-reader: Listens on port 80 and returns the contents of /mnt/index.html.  This simulate an application serving the data from the local filesystem.
* 1 service of type LoadBalancer
  * This provides an external endpoint for busybox-reader so the user can see the latest timestamp
![AKS Volumes](Resources/aks-volumes.png)



### Sub-Challenge 1: Deploy Azure Disk with PVC

For this challenge:
* Deploy the Service, PVC and Pod in [the sample yaml](Resources/azure-disk-pvc-example.yaml)
* Validate that the Service has a Public IP, the PVC is bound and the Pod is running
  * HINT: To see the write is being written to: `kubectl exec <POD> -- tail -f /mnt/index.html`

### Sub-Challenge 1: Success Criteria

* Validate that the pod is writing new logs every second:
  * HINT: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail -r | head -20'`

Now that the service, pod and PVC have been verified, simulate failures:
* Kill the pod
  * HINT: To see the update of the nodes: `kubectl get pods -o wide -w`
  * Validate the service recovers
  * NOTE: There might be a pause in the service and a gap in the logs
* Reboot the node the pod is running
  * Validate the service stays up
  * NOTE: There should DEFINITELY be a pause in the service and a gap in the logs

### Sub-Challenge 2: Deploy Azure Files with NFS with PVC

In the previous sub-challenge, the service, PVC and deployment were generated for you.  In this sub-challenge, use the previous YAML to create the same scenario with the following changes:
* Using Azure Files with NFS instead of an Azure Disk
* Change the Deployment replicas to 2

NOTE: [You might need to Register the feature in your subscription](https://github.com/kubernetes-sigs/azurefile-csi-driver/tree/master/deploy/example/nfs)

### Sub-Challenge 2: Success Criteria

* Validate that the pod is writing new logs every second:
  * HINT: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail -r | head -20'`

Now that the service, pod and PVC have been verified, simulate failures:
* Kill the pod
  * Validate the service stays up
  * NOTE: There should be NO gap in the logs
* Reboot the node the pod is running
  * Validate the service stays up
  * NOTE: There should be NO gap in the logs