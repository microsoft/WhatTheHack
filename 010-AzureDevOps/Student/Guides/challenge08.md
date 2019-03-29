# What the Hack: DevOps 

## Challenge 8 – Azure Pipelines: Continuous Delivery Part 2
[Back](challenge07.md) - [Home](../../readme.md)

### Introduction

We have created a release pipeline to deploy our application to an integration environment. However, I have a feeling that your applications will need to be released to production and that before they go to production they will need some sort of sign off from some stakeholders. 

### Challenge

In this challenge we will create a production environment and then configure our release pipeline to get human approval before shipping code to that environment. 

1. In our release pipeline clone our existing Integration stage. Rename the new stage Production.
2. Set a pre-deployment condition so that one of your teammates has to approve any deployment before it goes to production. 
3. Update the tasks on the pipeline changing everything that says “-integration” to “-production”. HINT: you should need to change this in 2 places.
4.  Trigger a new release manually to test out the changes you made.


### Success Criteria

1. Has the use of Infrastructure as Code made easier? How? 
2. Find your new production instance in the Azure Portal. What was created? Navigate to the running site.

    > NOTE: in this example we deployed everything to the same resource group and App Service Plan. In a real application you will likely want to separate the deployment to different ones. 


[Back](challenge07.md) - [Home](../../readme.md)
