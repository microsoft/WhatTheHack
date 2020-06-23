# What The Hack - Intro To Kubernetes
## Introduction
Welcome to the coach's guide for the Intro to Kubernetes What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

## Coach's Guides
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](00-prereqs.md)**
   - Prepare your workstation to work with Azure, Docker containers, and AKS
- Challenge 1: **[Got Containers?](01-containers.md)**
   - Package the "FabMedical" app into a Docker container and run it locally.
- Challenge 2: **[The Azure Container Registry](02-acr.md)**
   - Deploy an Azure Container Registry, secure it and publish your container.
- Challenge 3: **[Introduction To Kubernetes](03-k8sintro.md)**
   - Install the Kubernetes CLI tool, deploy an AKS cluster in Azure, and verify it is running.
- Challenge 4: **[Your First Deployment](04-k8sdeployment.md)**
   - Pods, Services, Deployments: Getting your YAML on! Deploy the "FabMedical" app to your AKS cluster. 
- Challenge 5: **[Scaling and High Availability](05-scaling.md)**
   - Flex Kubernetes' muscles by scaling pods, and then nodes. Observe how Kubernetes responds to resource limits.
- Challenge 6: **[Deploy MongoDB to AKS](06-deploymongo.md)**
   - Deploy MongoDB to AKS from a public container registry.
- Challenge 7: **[Updates and Rollbacks](07-updaterollback.md)**
   - Deploy v2 of FabMedical to AKS via rolling updates, roll it back, then deploy it again using the blue/green deployment methodology.
- Challenge 8: **[Storage](08-storage.md)**
   - Delete the MongoDB you created earlier and observe what happens when you don't have persistent storage. Fix it!
- Challenge 9: **[Helm](09-helm.md)**
   - Install Helm tools, customize a sample Helm package to deploy FabMedical, publish the Helm package to Azure Container Registry and use the Helm package to redeploy FabMedical to AKS.
- Challenge 10: **[Networking](10-networking.md)**
   - Explore different ways of routing traffic to FabMedical by configuring an Ingress Controller with the HTTP Application Routing feature in AKS.
- Challenge 11: **[Operations and Monitoring](11-opsmonitoring.md)**
   - Explore the logs provided by Kubernetes using the Kubernetes CLI, configure Azure Monitor and build a dashboard that monitors your AKS cluster