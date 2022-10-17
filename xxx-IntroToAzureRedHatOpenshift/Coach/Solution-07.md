# Challenge 07 - Scaling - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance
- In this challenge, we will be scaling up the number of pods we have.

## Scaling by manually editing deployment definition
- In the `.YAML` file, find the line that states `replicas: 1` and change that to `replicas: 3`, then save and quit
  - It will look like:
  ```
  spec:
    selector:
      matchLabels:
        app: ostoy-microservice
    replicas: 3
  ```
- Execute the following command `oc apply -f network.yaml`
- In the portal's left menu, click on *Workloads > Deployments > rating-api* and confirm that there is more than one pod running

## Scaling using Command Line
- Scale the pods using the command `oc scale deployment --replicas=3` 
- Confirm using the command `oc get pods` 


// Scale using autoscaler by sending a bunch of pings/curl to the web api to the route you got from challenge 2

// Need resource limits on the deployment
In portal:

in cli:
`oc get dc`

``

``

Autoscale pods to max 5 and watch
`oc autoscale deployment/rating-web --min=1 --max=10 --cpu-percent=25`

Check pods while autoscaling
`oc get pods -w`

Deploy the spam to test autoscaling
`kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- <web-service-route-url>; done"`

`kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- http://rating-web-expose.apps.urjfps3a.eastus.aroapp.io/#/ ; done"`

Kill the spam
`kubectl delete deployment busybox`

`ctrl+c`

`oc delete horizontalpodautoscalers.autoscaling rating-web`