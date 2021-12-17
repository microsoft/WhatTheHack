# Coach Guide

## Solutions
- Solution 0: **[Install tools and Azure pre-requisites](Coach/Solution-00.md)**
   - Install the pre-requisites tools and software as well as create the Azure resources required for the workshop.
- Solution 1: **[Run the application](Coach/Solution-01.md)**
   - Run the Traffic Control application to make sure everything works correctly
- Solution 2: **[Add Dapr service invocation](Coach/Solution-02.md)**
   - Add Dapr into the mix, using the Dapr service invocation building block.
- Solution 3: **[Add pub/sub messaging](Coach/Solution-03.md)**
   - Add Dapr publish/subscribe messaging to send messages from the TrafficControlService to the FineCollectionService.
- Solution 4: **[Add Dapr state management](Coach/Solution-04.md)**
   - Add Dapr state management in the TrafficControl service to store vehicle information.
- Solution 5: **[Add a Dapr output binding](Coach/Solution-05.md)**
   - Use a Dapr output binding in the FineCollectionService to send an email.
- Solution 6: **[Add a Dapr input binding](Coach/Solution-06.md)**
   - Add a Dapr input binding in the TrafficControlService. It'll receive entry- and exit-cam messages over the MQTT protocol.
- Solution 7: **[Add secrets management](Coach/Solution-07.md)**
   - Add the Dapr secrets management building block.
- Solution 8: **[Deploy to Azure Kubernetes Service (AKS)](Coach/Solution-08.md)**
   - Deploy the Dapr-enabled services you have written locally to an Azure Kubernetes Service (AKS) cluster.
