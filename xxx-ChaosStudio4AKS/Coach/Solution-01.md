# Challenge 01 - Is your Application ready for the Super Bowl? - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This challenge is where the student will simulate a POD failure. For Chaos Studio to work with AKS, Chaos Mesh will need to be installed.
Chaos doesn't work with private clusters. 

- Instructions to install chaos studio are at https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal#set-up-chaos-mesh-on-your-aks-cluster
- Once installed, create a POD failure experiment to fail a POD
    - If using the Pizza App, the application should become unresponsive 

Have the student explore how to make PODs resilient by creating a replica of the POD

```bash
kubectl scale deployment -n APPNAME NAMESPACE --replicas=2
```

