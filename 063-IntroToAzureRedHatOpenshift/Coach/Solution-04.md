# Challenge 04 - Storage - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance
- In this challenge, we will connect MongoDB to our application in order to fix some of the application errors
- To do this, we will deploy a container image from Docker hub to easily deploy the database service. Mandatory environment variables can be passed in through the command line this way

## Deploy the MongoDB database 
- Use the command 
```
oc <your-mongodb-name> bitnami/mongodb \
  -e MONGODB_USERNAME=ratingsuser \
  -e MONDODB_PASSWORD=ratingspassword \
  -e MONGODB_DATABASE=ratingsdb \
  -e MONGODB_ROOT_USER=root \
  -e MONGODB_ROOT_PASSWORD=ratingspassword
```
  - This is successful if you go to the ARO console and see a new deployment for MongoDB
  - You can also use the command `oc get all` to view the status of the application and if the deployment was successful

  ## Retrieve MongoDB hostname for configuration
  - Find the MongoDB service using the command `oc get svc mongodb`
  - The service will be accessible at the following DNS name: `mongodb.workshop.svc.cluster.local` which is formed of `[service name].[project name].svc.cluster.local`
  - This name can also be retrieved from the ARO console
  - Instruct students to save this, because we will need it for the next challenge

  ## Retrieve rating-api hostname for configuration
- Using the command `oc get svc rating-api`, we can retrieve the `rating-api` hostname
  - The service will be accessible at the following DNS name over port 8080: `rating-api.workshop.svc.cluster.local:8080` which is formed of `[service name].[project name].svc.cluster.local`