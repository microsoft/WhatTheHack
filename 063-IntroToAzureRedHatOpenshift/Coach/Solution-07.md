# Challenge 07 - Scaling - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)** - [Next Solution >](./Solution-08.md)

## Notes & Guidance
- In this challenge, we will be scaling up the number of pods we have in our deployments.

## Scale Backend Application
- **In terminal:**
  - Scale the pods using the command `oc scale deployment rating-api --replicas=4` 
  - Confirm using the command `oc get pods` 

- **In web console:**
  - Go to *Workloads > Deployments > `rating-api` > Actions (in the top right) > Edit Pod Count*
    - Enter 4 and click save
  - Confirm by going to the *Details* tab

- **Using the YAML file:**
  - Go to *Workloads > Deployments > `rating-api` > YAML 
  - In the `YAML` file, find the line that states `replicas: 1` and change that to `replicas: 4`, then save and quit
    - It will look like:
    ```
    spec:
      replicas: 4
      selector:
        matchLabels:
          deployment: rating-web
    ```
  - Press save at the bottom of the screen
  - Confirm by going to the *Details* tab

## Scale Frontend Application
- **In terminal:**
  - Scale the pods using the command `oc scale deployment rating-web --replicas=2` 
  - Confirm using the command `oc get pods` 

- **In web console:**
  - Go to *Workloads > Deployments > `rating-web` > Actions (in the top right) > Edit Pod Count*
    - Enter 2 and click save
  - Confirm by going to the *Details* tab

- **Using the YAML file:**
  - Go to *Workloads > Deployments > `rating-web` > YAML 
  - In the `YAML` file, find the line that states `replicas: 1` and change that to `replicas: 2`, then save and quit
    - It will look like:
    ```
    spec:
      replicas: 2
      selector:
        matchLabels:
          deployment: rating-web
    ```
  - Press save at the bottom of the screen
  - Confirm by going to the *Details* tab

## Pod Autoscaling (Optional):

- **Set Resource Limits:**
  - Go to *Workloads > Deployments > `rating-web` > Actions (in the top right) > Edit Resource Limits*
    - Under *CPU > Request* enter **500** and select **millicores**
    - Under *CPU > Limit* enter **1** and select **cores**
    - Scroll down and click save

- **Add Horizontal Pod Autoscaler:**
  - Go to *Workloads > Deployments > `rating-web` > Actions (in the top right) > Add HorizontalPodAutoscaler*
  - Scroll down to minimum pods and enter **1**
  - Scroll down to maximum pods and enter **3**
  - Scroll down and click save

- **Increase Traffic To Frontend:**
  - Copy the frontend application URL to the clipboard
  - Deploy the following application and replace  `<rating-web-url>` with the frontend application route using the command below:
    - **NOTE**: This will increase the traffic to the frontend application. After a few minutes we should see the `rating-web` deployment have more than 1 pod deployed
  ```
  kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- <rating-web-url>; done"
  ```
  - Delete the `busybox` deployment using the command: `kubectl delete deployment busybox`