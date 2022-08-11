# Challenge 05 - Configuration - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance
- In this challenge, we will be configuring our database in order for application to be able to access it
- We will be using the service hostname from the previous challnege in order to do this

## Create in the web portal
- Navigate to the project and in the `rating-api` deployment, navigate to the deployment details
- In deployment details, navigate to the Environment tab 
- Create the **MONGODB_URI** environment variable
  - The variable should look like `mongodb://[username]:[password]@[endpoint]:27017/ratingsdb`
    - This uses the username and password, as well as the endpoint with the hostname that we set in the previous challenge
    - For reference, the variables we set were:
    ```
    MONGODB_USERNAME=ratingsuser
    MONGODB_PASSWORD=ratingspassword
    MONGODB_DATABASE=ratingsdb
    MONGODB_ROOT_USER=root
    MONGODB_ROOT_PASSWORD=ratingspassword
    ```
- Create the **API** variable 
  - The variable should look like `http://rating-api:8080`
- Make sure to **save** changes!

## Create using the CLI
- The **MONGODB_URI** variable can be set using the command:
`oc set env deploy/rating-api MONGODB_URI=mongodb://ratingsuser:ratingspassword@mongodb.workshop.svc.cluster.local:27017/ratingsdb`
- The **API** variable can be set using the command: `oc set env deploy rating-web API=http://rating-api:8080`

## Expose service using a Route
- Expose the service using the command `oc expose svc/rating-web` 
- Find the created route hostname using the command `oc get route rating-web`
  - Example output will give a `HOST/PORT` of `rating-web-workshop.apps.zek7o8x6.eastus.aroapp.io`
  - If you put this hostname in the browser, you should be able to access the application, this time with a working database 
    - This can be tested by submitting a few votes and seeing if the data persists