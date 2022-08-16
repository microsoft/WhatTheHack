# Challenge 02 - The Azure Container Registry - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Choose Your Path!

**Attention Coach:** As per the [Coach Guidance for Challenge 1](./Solution-01.md), there are four paths to choose for Challenges 1 through 3. You will need to select a proper path based on the learning objectives of the organization (to be decided PRIOR TO the hack!). Select the proper path after consulting with the organization's stakeholder(s) for the hack.

The coach guides for each of the three ACR challenges are below:

### [ACR Path A](Solution-02A.md)

### [ACR Path B](Solution-02B.md)

### [ACR Path C](Solution-02C.md)


* **[PATH A](./Solution-01A.md)**: Use this path to provide students with a comprehensive experience of building, testing, and running containers locally. Students will create a VM (using a provided ARM template) with Docker and all other required tools to ensure uniformity of environments. In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry. 
* **[PATH B](./Solution-02B.md)**: Use this path if your students understand Docker, don't care about building images locally, and/or have environments issues that would prevent them from building containers locally. In this path, your students will be given a Dockerfile, will create an Azure Container Registry, and then will use ACR tasks to build the images natively inside ACR.
* **[PATH C](./Solution-02C.md)**: Use this path to skip any work with docker & containers, but you still want to learn about ACR.  The path is similar to Path B, however in this case students will simply import pre-staged containers from DockerHub into ACR (eg, there is no container building involved)