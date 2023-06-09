# Challenge 06 - Networking - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance
- In this challenge, we will be creating three network policies to demonstrate how to restrict communication in a cluster

## Switch to Administrator Mode
- **In terminal:**
  - Run the command `oc whoami`
    - The output displayed should show `kube:admin`
    ```
    kube:admin
    ```
  - **NOTE:** If the console does not show `kube:admin`, follow the solution found in [Challenge 01 - ARO Cluster Deployment - Coach's Guide](./Solution-01.md)

- **In web console:**
  - In the top left corner, under the Red Hat OpenShift Logo, there will be a dropdown that when clicked on, will show Administrator and Developer tabs
  - Click on the **Administrator** tab

## Create `deny-all` Network Policy
- This will create a network policy that denies all ingress traffic to all pods
- **Create in terminal:**
  1) Navigate your terminal to the location `deny-all.yaml` is located
  2) Use the command `oc apply -f deny-all.yaml` to create the network policy

- **Create in web console:**  
  1) Go to *Networking > Network Policies > **Create Network Policy***
  2) Go to YAML view
  3) Drag and drop the `deny-all.yaml` file into the editor
  4) Click create to create the network policy
  - **NOTE:** For step 3, you can also copy and paste the contents of YAML file into the YAML editor

## Create `allow-rating-web` Network Policy
- This will create a network policy that allows all ingress traffic to any pod matching the `deployment=rating-web` label

- **Create in terminal:**
  1) Navigate your terminal to the location `allow-rating-web.yaml` is located
  2) Use the command `oc apply -f allow-rating-web.yaml` to create the network policy

- **Create in web console:**  
  1) Go to *Networking > Network Policies > **Create Network Policy***
  2) Go to YAML view
  3) Drag and drop the `allow-rating-web.yaml` file into the editor
  4) Click create to create the network policy
  - **NOTE:** For step 3, you can also copy and paste the contents of YAML file into the YAML editor

## Create `allow-rating-api` Network Policy
- This will create a network policy that applies to any pod matching the `deployment=rating-api` label and allow ingress only from pods matching the `deployment=rating-web` label

- **Create in terminal:**
  1) Navigate your terminal to the location `allow-rating-api.yaml` is located
  2) Use the command `oc apply -f allow-rating-api.yaml` to create the network policy

- **Create in web console:**  
  1) Go to *Networking > Network Policies > **Create Network Policy***
  2) Go to YAML view
  3) Drag and drop the `allow-rating-api.yaml` file into the editor
  4) Click create to create the network policy
  - **NOTE:** For step 3, you can also copy and paste the contents of YAML file into the YAML editor