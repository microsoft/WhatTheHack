# Challenge 7 - Data Volumes

[< Previous Challenge](./06-service-mesh.md)

## Introduction

When working with cloud native applications, the ideal place for storing data is in object/blob storage.  However, that isn't always possible, and some applications need to access file storage.  Kubernetes uses Persistent Volumes and Persistent Volume Claims to manage volumes mounted inside running containers.

A persistent volume represents storage that has been provisioned for use with Kubernetes pods. A persistent volume can be used by one or many pods, and can be dynamically or statically provisioned.

The storage solution options for AKS are:
* Azure Managed Disk - Only mountable to one VM at a time.
* Azure Files - Uses SMB protocol, mountable to multiple VM at a time
* NFS - Allows containers across VM's to mount the same volume.  At this time, you must bring your own NFS Server
* [Azure NetApp Files](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction) - An enterprise-class, high-performance, metered file storage service running on Azure

The Kubernetes concepts for storage are:
* [Storage Class](https://kubernetes.io/docs/concepts/storage/storage-classes/) (SC) - Describes the "profile" of the storage solution.  (e.g. Azure Disk with LRS)
* [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) (PV) - A storage instance (e.g. A specific Azure Disk resource)
* [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) (PVC) - A request for a storage instance (e.g. Request for a 30Gi disk with a Storage Class).  When this request is fulfilled, it will create a Persistent Volume.

## Description

In this challenge, we will create a PVC for an Azure Disk and attach it to pod.  Then we will shutdown the node and watch the Azure Disk re-attach to the other node with the pod.

- Create a PVC for an 1Gi Azure Disk with the name `azure-disk-pvc`
- Deploy this [sample app](./Resources/azure-disk-deployment.yaml) which reads and writes to the PVC.  

Deployment details:
* Mounts a PVC names `azure-disk-pvc` to `/mnt/azure-disk` inside 2 containers
* Two containers:
  * busybox-writer: Every second, appends the current timestamp to /mnt/azure-disk/index.html
  * busybox-reader: Serves /mnt/azure-disk/index.html on port 80

- Create and expose the service using Ingress
- In a separate window, get the latest timestamp results
    - HINT: `watch "curl $INGRESS_IP | tail -r | head -20"

- Delete the pod
    - It should restart on the same node.  
- Cordon the node
    - Make sure you have at least 2 nodes
- Delete the pod
- Verify the PVC and Pod successfully start on a new node

## Success Criteria

- 