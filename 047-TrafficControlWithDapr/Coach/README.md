# Coach Guide

## Introduction
Welcome to the coach's guide for the Traffic Control with Dapr What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide.  Don't cheat yourself by looking at these during the hack!  Go learn something. :)

## Solutions
- Challenge 0: **[Install local tools and Azure prerequisites](Solution-00.md)**
   - Install the pre-requisites tools and software as well as create the Azure resources required.
- Challenge 1: **[Run the TrafficControl application](Solution-01.md)**
   - Run the Traffic Control application to make sure everything works correctly.
- Challenge 2: **[Dapr Service Invocation](Solution-02.md)**
   - Add Dapr into the mix, using the Dapr service invocation building block.
- Challenge 3: **[Dapr Pub/Sub Messaging](Solution-03.md)**
   - Add Dapr publish/subscribe messaging to send messages from the `TrafficControlService` to the `FineCollectionService`.
- Challenge 4: **[Dapr Pub/Sub Messaging](Solution-04.md)**
   - Add Dapr state management in the `TrafficControlService` to store vehicle information.
- Challenge 5: **[Dapr SMTP Output binding](Solution-05.md)**
   - Use a Dapr output binding in the `FineCollectionService` to send an email.
- Challenge 6: **[Dapr MQTT Input Binding](Solution-06.md)**
   - Add a Dapr input binding in the `TrafficControlService`. It'll receive entry- and exit-cam messages over the MQTT protocol.
- Challenge 7: **[Dapr Secrets Management](Solution-07.md)**
   - Add the Dapr secrets management building block.
- Challenge 8: **[Dapr-enabled Services running in Azure Kubernetes Service (AKS)](Solution-08.md)**
   - Deploy the Dapr-enabled services you have written locally to an Azure Kubernetes Service (AKS) cluster.
