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

## Success Criteria

This challenge has multiple, independent sub-challenges.  Complete each of them to complete the Data Volumes challenge.

Instead of creating all of the required Kubernetes resources from scratch, the first set of resources are given to you to deploy and should work as-is.  In subsequent sub-challenges, you must clone and modify the working example to fit the challenge requirements.

## Architecture

The architecture for the sample pod is:

* 1 pod with 2 containers
  * busybox-writer: every 1 second, will append the current timestamp to /mnt/index.html.  This simulates an application writing data to a local filesystem.
  * busybox-reader: Listens on port 80 and returns the contents of /mnt/index.html.  This simulate an application serving the data from the local filesystem.
* 1 service of type LoadBalancer
  * This provides an external endpoint for busybox-reader so the user can see the latest timestamp

![AKS Volumes](img/aks-volumes.png)

### Sub-Challenge 1: Azure Disk with PVC

Deploy the sample StatefulSet using Azure Disk as a PVC, verify that it works and kill the pod and kill the node to see the impact.  

For this challenge:
* View the existing and default Storage Classes on your cluster
* Deploy the Service, PVC and Pod in [the sample yaml](Resources/azure-disk-pvc-example.yaml)
* Validate that the Service has a Public IP, the PVC is bound and the Pod is running
  * HINT: To see the write is being written to: `kubectl exec <POD> -- tail -f /mnt/index.html`

### Sub-Challenge 1: Success Criteria

After installing the resources, verify they are working:
* Validate the StatefulSet, Pods, PVC and PV
  * You should have 1 Service with a Public IP, 1 Ready StatefulSet, 1 Pod Running, 1 Bound PVC and 1 Bound PV
* Validate that the Pod is writing new logs every second:
  * HINT: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail | head -20'`

Now that the service, pod and PVC have been validated, simulate failures:
* Kill the pod and determine the impact (e.g. `kubectl delete pod`)
  * HINT: To see the update of the nodes: `kubectl get pods -o wide -w`
  * Validate the service recovers
* Reboot the node and determine the impact (e.g. `az vmss restart`)
  * HINT: To see the status of nodes: `kubectl get nodes -o wide -w`
  * Validate the service recovers
* Cordon the node, kill the pod and determine the impact
  * HINT: `kubectl cordon`
  * Validate the pod comes up on a different node

Scale your app:
* Change the replica from 1 to 2
  * Validate you have: 1 Ready StatefulSet, 2 Pods Running, 2 Bound PVC and 2 Bound PV 
  * What impact to the curl output do you notice?

### Sub-Challenge 2: Azure Files with NFS with PVC

In the previous sub-challenge, the service, PVC and deployment were generated for you.  In this sub-challenge, use the previous YAML to duplicate scenario with the following changes:

* Using Azure Files with NFS instead of an Azure Disk
* Change the Deployment replicas to 2

NOTE: [You might need to Register the feature in your subscription and create a Storage Class](https://github.com/kubernetes-sigs/azurefile-csi-driver/tree/master/deploy/example/nfs)

### Sub-Challenge 2: Success Criteria

* Validate that the pod is writing new logs every second:
  * HINT: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail -r | head -20'`

Now that the service, pod and PVC have been verified, simulate failures:
* Kill one the pods
  * Validate the service stays up
  * NOTE: There should be NO gap in the logs
* Reboot the node the pod is running
  * Validate the service stays up
  * NOTE: There should be NO gap in the logs

### Sub-Challenge 3: Azure Disk with NFS with PV

In the previous sub-challenges you used a PVC, which created the Disk for you.  However, sometimes, you need to use an existing disk.  In this sub-challenge, copy the YAML from sub-challenge 1 with the following changes:

* Create an Azure Disk 
* Remove the PVC resource
* Use the Azure Disk as a PV and mount to the same volume

### Sub-Challenge 3: Success Criteria

* Validate that the pod is writing new logs every second:
  * HINT: In separate window, run: `watch -n 1 'curl -s <PUBLIC IP> | tail -r | head -20'`
* In the portal, validate that the drive you created is consuming Throughput and IOPS
* Kill the pod and determine the impact (e.g. `kubectl delete pod`)
  * HINT: To see the update of the nodes: `kubectl get pods -o wide -w`
  * Validate the service recovers

## Hints

* [Configure a Pod to Use a PersistentVolume for Storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)
* [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Persistent Volume Claims]()
