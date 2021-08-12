# Challenge 7: Coach's Guide - Data Volumes

[< Previous Challenge](06-service-mesh.md) - **[Home](README.md)**

## Sub-challenge 1: Static provisioning with Azure Disks

### Provision an Azure Disk

If availability zones are enabled, the disk will need to live in the same zone as the node that the pod is running on to attach.

```bash
NRG=$(az aks show -n $AKS_NAME -g $RG -o json | jq '.nodeResourceGroup' -r)
echo $NRG

# if availability zones are NOT enabled
az disk create -g $NRG -n managed-disk-1 --size-gb 5

# if availability zones are enabled
az disk create -g $NRG -n managed-disk-1 --size-gb 5 --zone 1

# Get the Resource ID
az disk show -n managed-disk-1 -g $NRG -o json | jq '.id' -r
```

### Use the disk in the deployment yaml

Make sure that diskName and diskURI match and point to the same disk. See [static-disk-deployment.yaml](../Resources/07-data-volumes/static-disk-deployment.yaml) for an example.

### Deploy the yaml file and verify the application has deployed successfully

```bash
$ kubectl get deploy
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
static-disk-app   1/1     1            1           20m

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
static-disk-app-5dbd479c7f-74kfj   2/2     Running   0          20m

$ kubectl get svc
NAME               TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
static-disk-app    LoadBalancer   10.0.6.84     40.88.193.218   80:31591/TCP   20m

$ export PUBLIC_IP=$(kubectl get svc -o json | jq  '.items[0].status.loadBalancer.ingress[0].ip' -r)
```

### Stream contents of persisted file

You should see something like the below:

```
$ watch -n 1 'curl -s $PUBLIC_IP | tail | head -20'
2021-03-24:22:55:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:12 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:13 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:14 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:15 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:16 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:18 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:19 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:20 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:06:21 - static-disk-app-5dbd479c7f-74kfj
```

### Check persistence

Verify that the timestamps are continued. If it is unclear from the stream, run `curl $PUBLIC_IP` to check.

### Scaling

What happens if you try to scale the application? One of two things:

1. Multiple pods are scheduled on the same node. Due to the way the infrastructure works, since the data disk is attached to the node, the pods can share the same volume. Thus both pods will persist to the same location and the stream will look like this:

```
2021-03-24:22:55:17 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:21 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:22 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:22 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:23 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:23 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:24 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:24 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:25 - static-disk-app-5dbd479c7f-jzg5n
2021-03-24:23:17:25 - static-disk-app-5dbd479c7f-74kfj
2021-03-24:23:17:26 - static-disk-app-5dbd479c7f-jzg5n
```

2. Pods are scheduled on different nodes. Due to the way the infrastructure works, a disk can usually only be attached to a single node. The second pod will try to attach the disk to the node it runs on and fail.

## Sub-challenge 2: Dynamic provisioning with Azure Disks

### Use PVCs in the deployment yaml

See [dynamic-disk-deployment.yaml](../Resources/07-data-volumes/dynamic-disk-deployment.yaml).

### Deploy the yaml file and verify the application has deployed successfully

```bash
$ kubectl get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
disk-app   1/1     1            1           2m37s

$ kubectl get pod
NAME                      READY   STATUS    RESTARTS   AGE
disk-app-78d66989-dmr55   2/2     Running   0          2m39s

$ kubectl get svc
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
disk-app     LoadBalancer   10.0.32.228   52.191.218.25   80:30684/TCP   2m47s

$ kubectl get pvc
NAME                 STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
managed-disk-claim   Bound    pvc-b43420ee-b94b-4621-b60b-2ce3a03c45bc   5Gi        RWO            default        34s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
pvc-b43420ee-b94b-4621-b60b-2ce3a03c45bc   5Gi        RWO            Delete           Bound    default/managed-disk-claim   default                 35s
```

### Stream content of persisted file 

```
2021-03-24:23:45:44 - disk-app-78d66989-dmr55
2021-03-24:23:45:45 - disk-app-78d66989-dmr55
2021-03-24:23:45:46 - disk-app-78d66989-dmr55
2021-03-24:23:45:47 - disk-app-78d66989-dmr55
2021-03-24:23:45:48 - disk-app-78d66989-dmr55
2021-03-24:23:45:49 - disk-app-78d66989-dmr55
2021-03-24:23:45:50 - disk-app-78d66989-dmr55
2021-03-24:23:45:51 - disk-app-78d66989-dmr55
2021-03-24:23:45:52 - disk-app-78d66989-dmr55
2021-03-24:23:45:53 - disk-app-78d66989-dmr55
```

## Sub-challenge 3: Scaling persistent applications with Azure Disks

### Deploy the yaml file and verify the application has deployed successfully

```bash
$ kubectl get sts
NAME                       READY   AGE
managed-disk-statefulset   1/1     46s

$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
managed-disk-statefulset-0   2/2     Running   0          47s

$ kubectl get pvc
NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
managed-disk-volume-managed-disk-statefulset-0   Bound    pvc-61eab3a2-314c-4b06-af7c-e3971d037846   5Gi        RWO            default        50s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                    STORAGECLASS   REASON   AGE
pvc-61eab3a2-314c-4b06-af7c-e3971d037846   5Gi        RWO            Delete           Bound    default/managed-disk-volume-managed-disk-statefulset-0   default                 51s

$ kubectl get svc
NAME               TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
managed-disk-svc   LoadBalancer   10.0.142.223   20.42.39.51   80:32581/TCP   2m48s
```

### Stream content of persisted file 

```
Every 1.0s: curl -s 20.42.39.51 | tail | head -20                                       ubuntu: Thu Mar 25 00:05:18 2021

2021-03-25:00:05:08 - managed-disk-statefulset-0
2021-03-25:00:05:09 - managed-disk-statefulset-0
2021-03-25:00:05:10 - managed-disk-statefulset-0
2021-03-25:00:05:11 - managed-disk-statefulset-0
2021-03-25:00:05:12 - managed-disk-statefulset-0
2021-03-25:00:05:13 - managed-disk-statefulset-0
2021-03-25:00:05:14 - managed-disk-statefulset-0
2021-03-25:00:05:15 - managed-disk-statefulset-0
2021-03-25:00:05:16 - managed-disk-statefulset-0
2021-03-25:00:05:17 - managed-disk-statefulset-0
```

### Scale up statefulset

```bash
$ kubectl scale sts managed-disk-statefulset --replicas=2
statefulset.apps/managed-disk-statefulset scaled
```

Check on the additional resources provisioned.

```bash
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
managed-disk-statefulset-0   2/2     Running   0          5m2s
managed-disk-statefulset-1   2/2     Running   0          49s

$ kubectl get pvc
NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
managed-disk-volume-managed-disk-statefulset-0   Bound    pvc-61eab3a2-314c-4b06-af7c-e3971d037846   5Gi        RWO            default        5m4s
managed-disk-volume-managed-disk-statefulset-1   Bound    pvc-6ba497f9-613c-4277-88fd-49ba6e377a6b   5Gi        RWO            default        51s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                    STORAGECLASS   REASON   AGE
pvc-61eab3a2-314c-4b06-af7c-e3971d037846   5Gi        RWO            Delete           Bound    default/managed-disk-volume-managed-disk-statefulset-0   default                 5m4s
pvc-6ba497f9-613c-4277-88fd-49ba6e377a6b   5Gi        RWO            Delete           Bound    default/managed-disk-volume-managed-disk-statefulset-1   default                 50s
```

The stream should now switch between the two pods, alternating between the two outputs:

```
Every 1.0s: curl -s 20.42.39.51 | tail | head -20                                       ubuntu: Thu Mar 25 00:11:20 2021

2021-03-25:00:11:11 - managed-disk-statefulset-0
2021-03-25:00:11:12 - managed-disk-statefulset-0
2021-03-25:00:11:13 - managed-disk-statefulset-0
2021-03-25:00:11:14 - managed-disk-statefulset-0
2021-03-25:00:11:15 - managed-disk-statefulset-0
2021-03-25:00:11:16 - managed-disk-statefulset-0
2021-03-25:00:11:17 - managed-disk-statefulset-0
2021-03-25:00:11:18 - managed-disk-statefulset-0
2021-03-25:00:11:19 - managed-disk-statefulset-0
2021-03-25:00:11:20 - managed-disk-statefulset-0
```

```
Every 1.0s: curl -s 20.42.39.51 | tail | head -20                                       ubuntu: Thu Mar 25 00:10:53 2021

2021-03-25:00:10:44 - managed-disk-statefulset-1
2021-03-25:00:10:45 - managed-disk-statefulset-1
2021-03-25:00:10:46 - managed-disk-statefulset-1
2021-03-25:00:10:47 - managed-disk-statefulset-1
2021-03-25:00:10:48 - managed-disk-statefulset-1
2021-03-25:00:10:49 - managed-disk-statefulset-1
2021-03-25:00:10:50 - managed-disk-statefulset-1
2021-03-25:00:10:51 - managed-disk-statefulset-1
2021-03-25:00:10:52 - managed-disk-statefulset-1
2021-03-25:00:10:53 - managed-disk-statefulset-1
```

## Sub-Challenge 4: Scaling persistent applications with Azure Files

The correct construct to use here is a deployment. The statefulset as configured in sub-challenge 3 bundles the pod and the PVC into a single unit of scale. When the application is scaled, new storage is provisioned.

We do not need multiple storage. Therefore, a single PVC should be created and a deployment should be created with pods configured to use the same PVC.

### Create yaml

See [dynamic-files-deployment.yaml](../Resources/07-data-volumes/dynamic-files-deployment.yaml).

### Deploy the yaml file and verify the application has deployed successfully

```bash
$ kubectl get deploy
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
files-app   2/2     2            2           12m

$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
files-app-75858d768c-5b28p   2/2     Running   0          19s
files-app-75858d768c-66rc4   2/2     Running   0          12m

$ kubectl get pvc
NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
azure-files-claim                                Bound    pvc-e5071639-b252-4f60-a908-06c40155f6f1   5Gi        RWX            azurefile      12m

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                    STORAGECLASS   REASON   AGE
pvc-e5071639-b252-4f60-a908-06c40155f6f1   5Gi        RWX            Delete           Bound    default/azure-files-claim                                azurefile               12m

$ kubectl get svc
NAME               TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
files-app          LoadBalancer   10.0.129.252   20.42.33.25   80:30759/TCP   12m
```

### Stream content of persisted file 

```
Every 1.0s: curl -s 20.42.33.25 | tail | head -20                                       ubuntu: Thu Mar 25 00:34:28 2021

2021-03-25:00:34:23 - files-app-75858d768c-66rc4
2021-03-25:00:34:24 - files-app-75858d768c-5b28p
2021-03-25:00:34:24 - files-app-75858d768c-66rc4
2021-03-25:00:34:25 - files-app-75858d768c-5b28p
2021-03-25:00:34:26 - files-app-75858d768c-66rc4
2021-03-25:00:34:26 - files-app-75858d768c-5b28p
2021-03-25:00:34:27 - files-app-75858d768c-66rc4
2021-03-25:00:34:27 - files-app-75858d768c-5b28p
2021-03-25:00:34:28 - files-app-75858d768c-66rc4
2021-03-25:00:34:28 - files-app-75858d768c-5b28p
```
