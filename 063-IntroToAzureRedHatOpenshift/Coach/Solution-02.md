# Challenge 02 - Application Deployment - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance
- In this challenge both the applications will be broken. Do not be alarmed, we will be fixing them in future challenges!
  - The backend API is broken because we will need to deploy a MongoDB backend and configure the environment variables on the deployment (Challenge 4 & 5)
  - The frontend application is broken because we will need to configure our environment variables on the deployment to point to our backend API (Challenge 5)

## Retrieve Login Command
- In the web console, retrieve the login command by clicking on the dropdown arrow next to your name in the top-right and select **Copy Login Command**
  - It was successful if you see something like `Logged into "https://api.abcd1234.westus.aroapp.io:6443" as "kube:admin" using the token provided.`

## Create New Project
- **Create in terminal:**
  - In the cluster, create a new project called "ratings-app" using the command `oc new-project ratings-app`
    - It was successful if you see something like `Now using project "ratings-app" on server "https://api.abcd1234.westus2.aroapp.io:6443"`
- **Create in web console:**
  - Go to *Home > Projects* and click on *Create Project* button on the right

## Deploy the backend API
- Deploy the backend API using the command `oc new-app <URL to coach created repo> --name=rating-api --strategy=docker`
  - **NOTE:** Make sure the students set the **--strategy** flag to **docker** when deploying the backend API and **--name** to **rating-api**
  - **Verify in terminal:**
    - Use the command `oc get deployments` and your output should look similar to below
    - **NOTE:** Verify the **READY** state shows 1/1
      ```
      NAME         READY   UP-TO-DATE   AVAILABLE   AGE
      rating-api   1/1     1            1           1d23h
      ```
  - **Verify in web console:**
    - Go to *Workloads > Deployments* and confirm the status of 'rating-api' shows **1 of 1 pods** deployed

## Deploy frontend application
- Deploy the frontend application using the command `oc new-app <URL to coach created repo> --name=rating-web --strategy=docker`
  - **NOTE:** Make sure the students set the **--strategy** flag to **docker** when deploying the frontend application and **--name** to **rating-web**
  - This build will take 5-10 minutes
  - Use the command `oc get deployments` and your output should look similar to below
    - **NOTE:** Verify the **READY** state shows 1/1
      ```
      NAME         READY   UP-TO-DATE   AVAILABLE   AGE
      rating-web   1/1     1            1           3d21h
      ```

## Enable access to the application in a browser
- Expose the service route using command `oc expose svc/rating-web`
- Get the route's hostname using command `oc get route rating-web`
  - **NOTE:** You should see a result with a `HOST/PORT` that looks similar to below 
  ```
  http://rating-web-project.apps.ibrnm3dw.eastus.aroapp.io/
  ```

## Challenge 2 Resource Files Original Repos (Do not fork. Create hack repos from the student directory resources)
- [Ratings Web](https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-web)
- [Ratings API](https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-api)