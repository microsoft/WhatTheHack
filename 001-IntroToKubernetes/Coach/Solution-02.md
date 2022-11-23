# Challenge 02 - The Azure Container Registry - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Attention Coaches!

 As per the [Coach Guidance for Challenge 1](./Solution-01.md), there are four paths to choose for Challenges 1 through 3. You will need to select a proper path based on the learning objectives of the organization (to be decided PRIOR TO the hack!). Select the proper path after consulting with the organization's stakeholder(s) for the hack.

![The Container Challenge Paths are mapped in this diagram.](../Images/wth-container-challenge-paths.png 'Container Challenge Paths')

### Choose Your Path:

The Coach's Guides for each of the four paths are below.

#### [PATH A](Solution-02A.md) - Challenge 2A Coach's Guide

 Use this path to provide students with a comprehensive experience of building, testing, and running containers locally. Students will create a VM (using a provided ARM template) with Docker and all other required tools to ensure uniformity of environments. In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry.

#### [PATH B](Solution-02B.md) - Challenge 2B Coach's Guide

Use this path if your students understand Docker, don't care about building images locally, and/or have environments issues that would prevent them from building containers locally. In this path, your students will be given a Dockerfile, will create an Azure Container Registry, and then will use ACR tasks to build the images natively inside ACR.

#### [PATH C](Solution-02C.md) - Challenge 2C Coach's Guide

Use this path to skip any work with Docker & containers, but you still want to learn about ACR.  The path is similar to Path B, however in this case students will simply import pre-staged containers from DockerHub into ACR (eg, there is no container building involved)

#### [PATH D](./Solution-03.md) - Challenge 3 Coach's Guide
Use this path to skip any work with Docker, containers, and ACR altogether. This path can also be used if students do not have "Owner" role permissions on their Azure subscription and thus will not be able to attach ACR to AKS.  Students will deploy our pre-built container images directly from DockerHub when creating their Kubernetes manifests.