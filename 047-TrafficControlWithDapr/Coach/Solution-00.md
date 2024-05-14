# Challenge 0 - Install local tools and Azure prerequisites - Coach's Guide

**[Home](./README.md)** - [Next Challenge>](./Solution-01.md)

## Notes & Guidance

The Coach should zip up the `/Student/Resources` directory as a "Resources.zip" file and give it to the students. It contains all of the source code files.

The most common errors are not installing all the prerequisites or credential problems due to having to connect to several different services (Azure, Azure Container Registry, Azure Kubernetes Service, kubectl, etc)

You may see errors like this on deployment of the Bicep template files:

```shell
Code: NoRegisteredProviderFound
Message: No registered resource provider found for location {location}
and API version {api-version} for type {resource-type}.
```

```shell
Code: MissingSubscriptionRegistration
Message: The subscription is not registered to use namespace {resource-provider-namespace}
```

This means the resource provider for that service hasn't been registered in the Azure subscription. The student should run the following command to register the resource provider:

```shell
az provider register --namespace {resource-provider-namespace}
```


If the student does not know their UPN, they can look it up using the CLI.  

```shell
az ad signed-in-user show
```

If a student has not installed the Dapr extensions before trying to add Dapr into their AKS cluster, then they will need to remove the Dapr extension through the Portal and re-add after they have run through the Dapr extension requirements.
