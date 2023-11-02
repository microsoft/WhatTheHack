# Challenge 05 - Configuration

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction
In challenge 4 we deployed a Mongo DB database as one step towards fixing one of our errors in challenge 3. For this challenge we will be configuring our backend and frontend applications to fix the errors we found in challenge 3.

## Description
In this challenge, we will need to configure our deployments. Your goal is to find out what environment variables need to be configured for the application to work.
- **HINT:** You will need to set two variables. Your goal is to figure out what will go into these variables and what deployments to configure them to.
    - **MONGODB_URI**=`Your Mongo DB URI`
    - **API**=`http://<backend service>:<backend service port> `

These variables can be created by using either the ARO Web Console or the OpenShift CLI, it's up to you! Once we set these variables, we will want to ensure that our application is now working. To do this, try exploring the application and see if data persists!

## Success Criteria
To complete this challenge successfully, you should be able to:
- Verify the creation of environment variables either using the ARO Web Console or the OpenShift CLI
- Demonstrate that your application is working

## Learning Resources
- [Managing Environment Variables](https://docs.openshift.com/aro/3/dev_guide/environment_variables.html)
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)