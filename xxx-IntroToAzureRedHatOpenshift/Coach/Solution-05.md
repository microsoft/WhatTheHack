# Challenge 05 - Configuration - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance
- In this challenge, we will be configuring both our frontend and backend applications in order for the web application to work. Our rating-api application needs to have an environment variable set for Mongo DB. The rating-web application needs to have an environment variable set for accessing the backend API.

## Create rating-api environment variable
- **Create in terminal:**
  - The **MONGODB_URI** variable can be set using the command:
  `oc set env deploy/rating-api MONGODB_URI=mongodb://[username]:[password]@[endpoint]:27017/ratingsdb` 
    - The students need to replace the `[username]` and `[password]` with the ones they used when creating the database in challenge 4. They'll also need to replace the `[endpoint]` with the hostname which is formed `[service name].[project name].svc.cluster.local` where `[service name]` is the name of our svc found using the command `oc get svc mongodb` and `[project name]` is the name of our ARO project which was created in challenge 2 which should be called `ratings-app`
      - For reference, the variables we set were:
      ```
      MONGODB_USERNAME=ratingsuser
      MONGODB_PASSWORD=ratingspassword
      MONGODB_DATABASE=ratingsdb
      MONGODB_ROOT_USER=root
      MONGODB_ROOT_PASSWORD=ratingspassword
      ``

- **Create in web console:**
  - Go to *Workloads > Deployments > `rating-api` > Deployment details > Environment*
  - Create an environment variable named **MONGODB_URI**
    - The variable *VALUE* should look like `mongodb://[username]:[password]@[endpoint]:27017/ratingsdb`
    - The students need to replace the `[username]` and `[password]` with the ones they used when creating the database in challenge 4. They'll also need to replace the `[endpoint]` with the hostname which is formed `[service name].[project name].svc.cluster.local` where `[service name]` is the name of our svc found using the command `oc get svc mongodb` and `[project name]` is the name of our ARO project which was created in challenge 2 which should be called `ratings-app`
      - For reference, the variables we set were:
      ```
      MONGODB_USERNAME=ratingsuser
      MONGODB_PASSWORD=ratingspassword
      MONGODB_DATABASE=ratingsdb
      MONGODB_ROOT_USER=root
      MONGODB_ROOT_PASSWORD=ratingspassword
      ``
    - **NOTE:** Make sure to **save** changes!

## Create rating-web environment variable

- **Create in terminal:**
  - The **API** variable can be set using the command: `oc set env deploy rating-web API=http://rating-api:8080`

- **Create in web console:**
  - Go to *Workloads > Deployments > `rating-web` > Deployment details > Environment*
  - Create an environment variable named **API** 
    - The variable *VALUE* should look like `http://rating-api:8080`
  - **NOTE:** Make sure to **save** changes!