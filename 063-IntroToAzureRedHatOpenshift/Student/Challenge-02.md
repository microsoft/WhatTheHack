# Challenge 02 - Application Deployment

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction
In this challenge, we will be deploying an application to Azure Red Hat OpenShift using an example application that tracks Fruit Smoothie Ratings. We will learn about deploying applications to ARO clusters and the steps needed to achieve that goal. The ratings application is a simple Node.js application that allows users to rate different fruit smoothies and view their ratings in a leaderboard.

The sample application is found in the two GitHub repositories provided in challenge 0 by your coach. You will be deploying your application using the GitHub repository URLs.

## Description
In this challenge we will deploy an application to our Azure Red Hat OpenShift cluster using two different build strategies. This challenge gives us an opportunity to see how to create a project on our cluster, as well as learn how to deploy our application's frontend and backend, and access our application from a browser.

- Create a new project called **ratings-app** in our cluster
- Deploy the backend API, using the GitHub repository provided by the coach, to our project using a **docker** build strategy and name the deployment **rating-api**
  - **NOTE:** Make sure you name your deployments when you deploy the applications!
- Deploy our frontend application to our project using a **docker** build strategy and name it **rating-web**
   - **NOTE:** Make sure you name your deployments when you deploy the applications!
- Expose our frontend service using an ARO **Route**
- Find and navigate to our application's homepage in the browser using the created route's hostname
  - **NOTE:** If you get the error **Application is not available** please make sure you are using HTTP and not HTTPS in your URL
  - **NOTE:** The build time for the applications may take 5-10 minutes
  - **NOTE:** When you navigate to your application's homepage, The website will be broken. Don't worry, we will be fixing this in future challenges!

## Success Criteria
To complete this challenge successfully, you should be able to:
- Verify that project has been created using the command `oc project` and find your project name in the list
- Verify that the application's frontend and backend have been deployed using either the OpenShift CLI or the ARO Web Console
- Demonstrate that you can access the application by navigating to application's homepage on a browser

## Learning Resources
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)
- [Creating New Applications](https://docs.openshift.com/container-platform/3.11/dev_guide/application_lifecycle/new_app.html)
- [Tutorial: Deploy application to Azure Red Hat OpenShift](https://docs.microsoft.com/en-us/azure/openshift/howto-deploy-with-s2i)
- [Creating applications using the CLI: Build Strategy Detection](https://docs.openshift.com/container-platform/4.8/applications/creating_applications/creating-applications-using-cli.html#build-strategy-detection)