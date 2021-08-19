# Challenge 1: Coach's Guide

[< Previous Challenge](./00-prereqs.md) - **[Home](README.md)** - [Next Challenge >](02-acr.md)

## COACHES:  READ THIS CAREFULLY!
There are four different options/paths for delivering Challenge 1.  You, the coach, need to select an appropriate path prior to delivering the hack.  When delivering the Hack, advise your students of the proper path to select based on the learning ojectives of the organization (to be decided PRIOR TO the hack!)  The four paths are:

* **[PATH A](./01a-containers.md)**: Use this path to provide students with a comprehensive experience of building, testing, and running containers locally. Students will create a VM (using a provided ARM template) with Docker and all other required tools to ensure uniformity of envuironments. In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry.
* **[PATH B](./02b-acr.md)**: Use this path if your students understand docker, don't care about building images locally, and/or have environments issues that would prevent them from building containers locally. In this path, your students will be given a Dockerfile, will create an Azure Container Registry, and then will use ACR tasks to build the images natively inside ACR.
* **[PATH C](./02c-acr.md)**: Use this path to skip any work with docker & containers.  The path is similar to Path B, but in this case students will simply import pre-staged containers into ACR (eg, there is no container building involved)
* **[PATH D](./03-k8sintro.md)**:  Use this path to skip using ACR altogether; can be used if students have a permission issue attaching ACR to AKS.  Students will use the images directly from DockerHub when creating their Kubernetes manifests.

