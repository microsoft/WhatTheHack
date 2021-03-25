# Challenge 7 - Data Volumes

[< Previous Challenge](./06-service-mesh.md)

## Introduction

When working with cloud native applications, the ideal location for persisting data is in SaaS Database or object/blob storage.  However, that isn't always possible, and some applications need to access local file storage.  Kubernetes uses Persistent Volumes and Persistent Volume Claims to manage volumes mounted inside running containers.

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

## Architecture

The architecture for the sample pod is:

* 1 pod with 2 containers
  * busybox-writer: every 1 second, will append the current timestamp to /mnt/index.html.  This simulates an application writing data to a local filesystem.
  * busybox-reader: Listens on port 80 and returns the contents of /mnt/index.html.  This simulate an application serving the data from the local filesystem.
* 1 service of type LoadBalancer
  * This provides an external endpoint for busybox-reader so the user can see the latest timestamp

![AKS Volumes](img/aks-volumes.png)

## Sub-Challenge 1: Static provisioning with Azure Disks

In this sub-challenge, we will provision an Azure Disk and attach it to your pods for persistence.

### Description

- Provision an Azure Disk in the `MC_<resource group>_<cluster name>_<region>` resource group.
    - **NOTE**: If you created a cluster with availability zones enabled, make sure to specify a zone when creating a disk. See [here](https://docs.microsoft.com/en-us/azure/aks/availability-zones#azure-disks-limitations).
- Modify disk-deployment.yaml to use the disk.
- Deploy the yaml file and verify the application has deployed successfully.
- Validate that the pod is writing new logs every second
    - **HINT**: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail | head -20'`
- Delete the pod. Another pod should automatically be started. Verify that the contents of the /mnt/index.html file have persisted.

### Success Criteria

- You have provisioned an Azure Disk.
- You have configured your application to use the disk.
- You have demonstrated persistence in your application.
- You have explained to your coach why scaling up the deployment may not work.

### Hints

- [Manually create and use a volume with Azure disks in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-disk-volume)

## Sub-challenge 2: Dynamic provisioning with Azure Disks

Most of the time, we have no interest in manually configuring storage for our application. In this challenge, we will use Persistent Volumes Claims to automatically provision storage.

### Description

- Delete the deployment from the previous sub-challenge.
- Modify the yaml from the previous sub-challenge to create and use a PVC.
- Deploy the yaml file and verify the application has deployed successfully.
- Verify that the persistent volume has been provisioned.
- Validate that the pod is writing new logs every second
    - **HINT**: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail | head -20'`
- Delete the pod. Another pod should automatically be started. Verify that the contents of the /mnt/index.html file have persisted.

### Success Criteria

- You have configured your application to dynamically provision storage.
- You have examined the persistent volume.
- You have demonstrated persistence in your application.

### Hints

- [Dynamically create and use a persistent volume with Azure disks in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-disks-dynamic-pv)
- [Configure a Pod to Use a PersistentVolume for Storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

## Sub-Challenge 3: Scaling persistent applications with Azure Disks

In this sub-challenge, we will learn how to scale an application where each instance of the application requires separate storage.

### Description

- Deploy disk-statefulset.yaml and verify the application has deployed successfully.
- Examine the PVC and PV created.
- Validate that the pod is writing new logs every second
    - **HINT**: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail | head -20'`
- Delete the pod. Another pod should automatically be started. Verify that the contents of the /mnt/index.html file have persisted.
- Scale up the StatefulSet. Check what happens to the /mnt/index.html file stream.

### Success Criteria

- You have demonstrated persistence in your application.
- You have scaled up your StatefulSet.
- You have explained to your coach what is a StatefulSet and why it is appropriate.

### Hints

- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [StatefulSet Basics](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)

















## Sub-Challenge 5: Dynamic provisioning with Azure Files

### Description

### Success Criteria

- You have explained to your coach why a StatefulSet is not appropriate.

### Hints

- [Dynamically create and use a persistent volume with Azure Files in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv)
