# Challenge 02 - Application Deployment - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Retrieve Login Command
- In the web console, retrieve the login command by clicking on the dropdown arrow next to your name in the top-right and select *Copy Login Command*
  - It was successful if you see something like `Logged into "https://api.abcd1234.westus.aroapp.io:6443" as "kube:admin" using the token provided.`

## Create New Project
- Create in terminal:
  - In cluster, create new project called "ratings-app" using the command `oc new-project ratings-app`
    - It was successful if you see something like `Now using project "ratings-app" on server "https://api.abcd1234.westus2.aroapp.io:6443"`
- Create in web console:
  - Go to *Home > Projects* and click on *Create Project* button on the right

## Access Github Repos
- Each student should fork this [repo](https://github.com/microsoft/rating-api) for the API, and this [repo](https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-web) for the frontend, in order to be able to setup webhooks

## Deploy the API
- Create new application in web console using the command `oc new-app https://github.com/<your GitHub username>/rating-api --strategy=source` with their corresponding Github username
  - It was successful if after `oc get pods`, the values under `NAME` are something like 
  ```
  rating-api-1-build 
  rating-api-7699b66cf5-7ch4w
  ```

## Deploy frontend Service
- Download updated Dockerfile and Footer.vue files using commands 
```
wget https://raw.githubusercontent.com/sajitsasi/rating-web/master/Dockerfile -O ./Dockerfile

wget https://raw.githubusercontent.com/sajitsasi/rating-web/master/src/components/Footer.vue -O ./src/components/Footer.vue
```
- Push changes to the repository 
- Deploy the frontend application using command `oc new-app https://github.com/<your GitHub username>/mslearn-aks-workshop-ratings-web --strategy=docker`
  - This build will take 5-10 minutes
  -   - It was successful if after `oc get pods`, the values under `NAME` are something like 
  ```
  mslearn-aks-workshop-ratings-web-1-build  
  mslearn-aks-workshop-ratings-web-5bfcbdbff6-h8755
  ```
- Set the environment variable `oc set env deploy mslearn-aks-workshop-ratings-web API=http://rating-api:8080`

## Navigate to application online
- Expose the service route using command `oc expose svc/mslearn-aks-workshop-ratings-web`
- Get the route's hostname using command `oc get route mslearn-aks-workshop-ratings-web`
  - You should see a result with a `HOST/PORT` that looks like 
  ```
  http://mslearn-aks-workshop-ratings-web-test.apps.ibrnm3dw.eastus.aroapp.io/
  ```