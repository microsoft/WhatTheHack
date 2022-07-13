# Challenge 02 - Application Deployment - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Retrieve Login Command
- In the web console, retrieve the login command by clicking on the dropdown arrow next to your name in the top-right and select *Copy Login Command*
  - It was successful if you see something like `Logged into "https://api.abcd1234.westus.aroapp.io:6443" as "kube:admin" using the token provided.`

## Create New Project
- Create in terminal:
  - In cluster, create new project called "OSToy" using the command `oc new-project ostoy`
    - It was successful if you see something like `Now using project "ostoy" on server "https://api.abcd1234.westus2.aroapp.io:6443"`
- Create in web console:
  - Go to *Home > Projects* and click on *Create Project* button on the right

## Deploy backend Microservice
- In terminal, use the command `oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-microservice-deployment.yaml`
  - It was successful if you see something like: 
    ```
    deployment.apps/ostoy-microservice created
    service/ostoy-microservice-svc created
    ```
## Deploy frontend Service
- Deploy frontend and create all objects with the command `oc apply -f https://raw.githubusercontent.com/microsoft/aroworkshop/master/yaml/ostoy-fe-deployment.yaml`
  - It was successful if you see something like 
    ```
    persistentvolumeclaim/ostoy-pvc created
    deployment.apps/ostoy-frontend created
    service/ostoy-frontend-svc created
    route.route.openshift.io/ostoy-route created
    configmap/ostoy-configmap-env created
    secret/ostoy-secret-env created
    configmap/ostoy-configmap-files created
    secret/ostoy-secret created
    ```
- Access application by getting the route
  - Use command `oc get route` and should see something like `ostoy-route-ostoy.apps.abcd1234.westus2.aroapp.io` which you can navigate to and see the homepage of the application
