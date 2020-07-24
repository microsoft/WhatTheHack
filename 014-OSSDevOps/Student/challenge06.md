# What the Hack: OSS DevOps 

## Challenge 06 - Package Application: Create Azure Container Registry and Push App Image to ACR
[Back](challenge05.md) // [Home](../readme.md) // [Next](challenge07.md)

### Introduction

Now that we have the containerized application running locally. Lets send the packaged application (aka containerized application) to an image repository. Any flavor of image repository can be used. However, in this hack use Azure Container Registry (aka ACR). Generally ACR is not sufficient and a package manager like JFrog's Artifactory, Nexus, npm or GitHubs Package Registry. However, to keep this application build simple we will not source our application dependencies from any of these sources but instead will use publicly avaliable [dependencies](Resources/Challenge-03/app/src/requirements.txt). 

### Challenge

The tasks in this challenge are to:
1. Create an Azure Container Registry (ACR)
2. Setup local Docker runtime to point to the newly created ACR
3. Push the containerized voting application to ACR
   

### Success Criteria

To successfully complete this challenge have the containerized application be pushed to ACR to be ready to be deployed anywhere.
   
[Back](challenge05.md) // [Home](../readme.md) // [Next](challenge07.md)