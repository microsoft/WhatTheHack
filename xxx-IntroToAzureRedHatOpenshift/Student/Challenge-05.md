# Challenge 05 - Configuration

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction
In the last challenge, we deployed a MongoDB database, but in this challenge, we will learn how to configure it to work and communicate with our application. 

## Description
In this challenge we create and environment variables in the appropriate pod in order for our database to work properly. Two variables will be created:

- **MONGODB_URI**=`mongodb://[username]:[password]@[endpoint]:27017/ratingsdb`
- **API**=`http://rating-api:8080`

These variables can be created either by using the web portal or the CLI, it's up to you! Once we set these variables, we will want to ensure that our application is now working, by pressing the buttons and seeing if data persists!

## Success Criteria
To complete this challenge successfully, you should be able to:
- Verify successful creation of environment variables
- Demonstrate working application

## Learning Resources
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)