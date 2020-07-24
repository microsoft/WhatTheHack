# What the Hack: OSS DevOps 

## Challenge 07 - CICD via Jenkins: Continuous Build
[Back](challenge06.md) // [Home](../readme.md) // [Next](challenge08.md)

### Introduction

Continuous integration is a process in which all development work is integrated as early as possible. The resulting artifacts are automatically created and tested. This process allows to identify errors as early as possible.

**Jenkins** is a popular open source tool to perform continuous integration and build automation. The basic functionality of Jenkins is to execute a predefined list of steps, e.g. to compile and test Python source code and build a container from the successful test results. The trigger for this execution can be time or event based. For example, every 20 minutes or after a new commit in a Git repository.

Possible steps executed by Jenkins are for example:

* Perform a software build using a build system like Apache Maven, Gradle, or PyBuilder
* Execute a shell script
* Archive a build result
* Running software tests
* Create containers
* Deploy containers

### Challenge

In this challenge, we will get familar with **Jenkins** and develop a set of *Jobs* and try to string together a couple of *Jobs* to make a pipeline that will test and create the container that have the voting application within it.

Perform the following tasks:
1. Deploy and setup a Jenkins instance
    * [Use Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/azure-oss.jenkins)
    * [**Advanced**] Deploy a Jenkins instance as an [Azure Container Instances (ACI) Container Group](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-container-groups)
2. Create a ```Jenkins Job``` that will: 
    *   Pull latest voting application code from the GitHub repo you created earlier in [Challenge 1](challenge01.md).
    *   Create a Docker container image
    *   Push the created container image to Azure Container Registry (ACR)

### Success Criteria

The success for this challenge is to be able deploy a functional Jenkins server and create a set of Jobs within that server that pull code, create container image and push that image up to a container repository.
   
[Back](challenge06.md) // [Home](../readme.md) // [Next](challenge08.md)