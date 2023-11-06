# Challenge 01: Is your Application ready for the Super Bowl? - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This challenge is where the student will simulate a pod failure. For Chaos Studio to work with AKS, Chaos Mesh will need to be installed.
Chaos Studio doesn't work with private AKS clusters. 

- Instructions to install chaos studio are at https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal#set-up-chaos-mesh-on-your-aks-cluster
- Once installed, create a pod failure experiment to fail a pod
    - If using the Pizza App, the application should become unresponsive 


Command to view the private and public IP of the pizza application 

```bash
kubectl get -n contosoappmysql svc

```

Command to view all names spaces running in the AKS cluster

```bash
kubectl get pods --all-namespaces

```
Have the student explore how to make PODs resilient by creating a replica of the POD

```bash
kubectl scale statefulset -n APPNAME NAMESPACE --replicas=2
```
- Have the student run the experiment again and notice how the application is available with a failed pod
  - In the experiment, make the mode = "one" versus "all: as per the JSON spec below:
     - {"action":"pod-failure","mode":"one","duration":"600s","selector":{"namespaces":["contosoappmysql"]}}

