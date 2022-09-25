# Challenge 01 - Got Containers? - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

## COACHES:  READ THIS CAREFULLY!
There are four different options/paths for delivering Challenges 1-3.  

BEFORE the hack, the Coach should discuss these paths with a stakeholder from the organization they are delivering the hack to. An appropriate path should be selected based on the learning objectives of the organization.

When delivering the hack, advise your students of the proper path to select from the Student guide based on the decision made with the stakeholder PRIOR TO the hack.  

### Challenges 1-3: Four Paths to Choose

[Challenge 1](./Solution-01A.md) has attendees start by taking the FabMedical sample application's source code, learn how to containerize it, and then run the application in Docker. We have found that this challenge often takes a significant amount of time (3+ hours) for attendees.

For organizations who are not focused on how to build container images, we have provided pre-built container images for the FabMedical sample application hosted in Dockerhub. This means you may choose to start the hack with either Challenge 2 or Challenge 3.

We have found it is common that some organizations do not allow their users to have the "Owner" role assigned to them in their Azure subscription. This means the attendees will not be able to configure the Azure Container Registry for use with their AKS cluster. 

You can workaround this either by skipping Challenge 2 altogether, or completing Challenge 2 to understand how ACR works, but then using the pre-built container images in Dockerhub for deployment in Challenge 4.

![The Container Challenge Paths are mapped in this diagram.](../Images/wth-container-challenge-paths.png 'Container Challenge Paths')

### Choose your path:

#### [PATH A](./Solution-01A.md) - Challenge 1A & 2A Coach's Guides
 Use this path to provide students with a comprehensive experience of building, testing, and running containers locally. Students will create a VM (using a provided ARM template) with Docker and all other required tools to ensure uniformity of environments. In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry. 
#### [PATH B](./Solution-02B.md) - Challenge 2B Coach's Guide
Use this path if your students understand Docker, don't care about building images locally, and/or have environments issues that would prevent them from building containers locally. In this path, your students will be given a Dockerfile, will create an Azure Container Registry, and then will use ACR tasks to build the images natively inside ACR.
#### [PATH C](./Solution-02C.md) - Challenge 2C Coach's Guide
Use this path to skip any work with Docker & containers, but you still want to learn about ACR.  The path is similar to Path B, however in this case students will simply import pre-staged containers from DockerHub into ACR (eg, there is no container building involved)
#### [PATH D](./Solution-03.md) - Challenge 3 Coach's Guide
Use this path to skip any work with Docker, containers, and ACR altogether. This path can also be used if students do not have "Owner" role permissions on their Azure subscription and thus will not be able to attach ACR to AKS.  Students will deploy our pre-built container images directly from DockerHub when creating their Kubernetes manifests.

**NOTE:** When choosing paths B, C, or D, the Coach should still cover the [lectures for Challenges 1, 2, and 3](Lectures.pptx?raw=true) before the students begin Challenge 3.

