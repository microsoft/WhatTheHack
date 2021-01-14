## Sub-challenge 1
```yaml
kubectl apply -f yaml/07-azure-disk-pvc-example.yaml
kubectl get pvc
kubectl get pv

export MANAGED_DISK_IP=`kubectl get svc/managed-disk-svc -o json  | jq '.status.loadBalancer.ingress[0].ip' -r`
echo $MANAGED_DISK_IP

# Validate service is up
curl $MANAGED_DISK_IP

watch -n 1 'curl -s $MANAGED_DISK_IP | tail -r | head -20'
```

## Sub-challenge 2
```yaml
kubectl apply -f yaml/07-azure-files-nfs-pvc-example.yaml
kubectl get pvc
kubectl get pv

export FILES_NFS_IP=`kubectl get svc/azure-files-nfs-svc -o json  | jq '.status.loadBalancer.ingress[0].ip' -r`
echo $FILES_NFS_IP

# Validate service is up
curl $FILES_NFS_IP

watch -n 1 'curl -s $FILES_NFS_IP | tail -r | head -20'
```
