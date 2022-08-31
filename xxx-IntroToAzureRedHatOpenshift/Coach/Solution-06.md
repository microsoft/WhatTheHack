# Challenge 06 - Networking - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance
- In this challenge, we will be creating a network policy to restrict communications to the API. 

## Switch to Cluster Console
- Switch to Administrator Console 
  - In the top left, under the Red Hat OpenShift Logo, there will be a dropdown that when clicked on, will show Administrator and Developer tabs
  - Click on **Administrator** tab
- In the project, expand the Networking dropdown (in the lefthand side menubar) and click **Create Network Policy**

## Create Network Policy
- Drag and drop the **network.YAML** file into the editor
  - Alternatively, can copy and paste contents of YAML file
  - This will create a policy that applies to any pod matching the `app=rating-api` label and allow ingress only from pods matching the `app=rating-web` label