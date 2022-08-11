# Challenge 02 - My Availability Zone burned down, now what? - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This challenge will simulate an AZ failure by failing a virtual machine that is a member of the Virtual Machines ScaleSet created by AKS. 
Chaos Studio will use the VMSS shutdown fault   

- Student will create experiment for VMSS shutdown 
- Have the student think about how to make the cluster resilient 
    - Student should scale VMSS 
      - Scale the VMSS via AKS
    - Scale the PizzaApp or the student's AKS deployment or statefulset 

Verify where your pods are running (Portal or CLI)

```bash
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=<node>

```
Scale the cluster to a minimum of 2 VMs

Scale your Kubernetes environment (hint it is a statefull deployment)

```bash
kubectl scale statefulset -n contosoappmysql contosopizza --replicas=2

```
