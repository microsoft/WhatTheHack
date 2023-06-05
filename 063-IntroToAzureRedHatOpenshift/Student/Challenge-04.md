# Challenge 04 - Storage

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction
In the previous challenge, we discovered that our application is not connected to any database, so in this challenge, we will be learning how to deploy a MongoDB database onto ARO so that our application can have persistent data.

## Description
In this challenge we will deploy a MongoDB database service. We will be using the OpenShift CLI to deploy a [bitnami/mongodb](https://hub.docker.com/r/bitnami/mongodb) container image from Docker Hub. 

The database should have the following variables:
  ```
  MONGODB_USERNAME=ratingsuser
  MONGODB_PASSWORD=ratingspassword
  MONGODB_DATABASE=ratingsdb
  MONGODB_ROOT_USER=root
  MONGODB_ROOT_PASSWORD=ratingspassword
  ```

Finally, once this has been deployed, you will also need to retrieve each service's hostname (the MongoDB and the rating-api) in order to complete the next challenge. 

## Success Criteria
To complete this challenge successfully, you should be able to:
- Successfully deploy the MongoDB service  
- Verify successful deployment by checking the application status
- Identify the MongoDB service's hostname and have it written down or stored somewhere for the next challenge
- Identify the `rating-api` service's hostname and have it written down or stored somewhere for the next challenge

## Learning Resources
- [Images on ARO](https://docs.openshift.com/container-platform/4.11/openshift_images/index.html)
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)
- [Create an application from Docker Hub Example](https://docs.openshift.com/container-platform/4.8/applications/creating_applications/creating-applications-using-cli.html#docker-hub-mysql-image)
- [Database Images - MongoDB](https://docs.openshift.com/aro/3/using_images/db_images/mongodb.html)