# Challenge 02 - Application Deployment

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction
In this challenge, we will see how to deploy an application to Azure Red Hat OpenShift using an example Fruit Smoothie Ratings application. 

The ratings application is a simple Node.js application that can allow users to rate different fruit smoothies and view the ratings leaderboard. For this challenge, let's set up our application!

## Description
In this challenge we will deploy an application to our Azure Red Hat OpenShift cluster using a source-to-image build strategy. This will give us an opportunity to see how to create a project on our cluster, as well as learn how to deploy our application's frontend and backend, and access our application on a browser.

- Create a new project called "ratings-app" in our cluster
- Deploy the ratings API to our project
- Deploy frontend service to our project
- Find and navigate to our application's homepage in the browser

## Success Criteria
To complete this challenge successfully, you should be able to:
- Verify that project has been created using the command `oc project ratings-app`
- Verify that frontend and backend have been deployed by using command `oc get pods`
- Demonstrate that you can access the application by navigating to application's homepage on a browser

## Learning Resources
- [ARO CLI Reference](https://docs.openshift.com/aro/3/cli_reference/index.html)
- [Tutorial: Deploy application to Azure Red Hat OpenShift](https://docs.microsoft.com/en-us/azure/openshift/howto-deploy-with-s2i)
- [Source-to-Image Build](https://docs.openshift.com/aro/3/using_images/s2i_images/nodejs.html)
