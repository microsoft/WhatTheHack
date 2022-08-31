# Challenge 03 - Logging and Metrics - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance
- The aim of this challenge is to have students explore the logging tools and debug the application to figure out what is wrong. In later challenges, we will fix these bugs, but for now, the students just need to find them using logging tools. 

Just to reiterate the errors in the application:
  - The backend API is broken because we will need to deploy a MongoDB backend and configure the environment variables on the deployment (Challenge 4 & 5)
  - The frontend application is broken because we will need to configure our environment variables on the deployment to point to our backend API (Challenge 5)

## Getting logs from CLI
- Get Pod Names
  - In the CLI, retrieve the name of the frontend pods to view pod logs using the command:
  `oc get pods -o name`
    - It was successful if you see something like
    ```
    pod/rating-web-build
    pod/rating-web-5bfcbdbff6-h8755
    pod/rating-api-build
    pod/rating-api-7699b66cf5-7ch4w 
    ```
- Get Errors from CLI
  - To look at the frontend pod logs, we can use the command `oc logs [pod name]` which as an example, would look like:
  ```
  oc logs pod/rating-api-7699b66cf5-7ch4w 
  ```
  - The error will show that there is no mongoDB connected, with an error beginning with `process.env.MONGODB_URI is undefined`

## Getting logs from ARO Console
- Make sure you are under the Administrator tab (shown on the top-left, there is also a Developer tab)
- Navigate to workloads from the menu on the left-hand side
- Under Workloads, navigate to Pods
- In Pods, there is a Logs tab (in between Environment and Events)
- In this tab, the logs will be shown