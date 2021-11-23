# Challenge 5 - Add a Dapr output binding

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

In this assignment, you're going to use a Dapr **output binding** in the FineCollectionService to send an email.

## Description

Dapr offers a *bindings* building block to easily interface with external systems. Bindings are divided into input bindings and output bindings. Input bindings trigger your services by picking up events from external systems. Output bindings are an easy way to invoke functionality of an external system. Both input and output bindings work without the developer having to learn the API or SDK of the external system. You only need to know the Dapr bindings API. See below for a diagram of how output bindings work:

<img src="../images/Challenge-05/output-binding.png" style="zoom: 50%;" />

For this hands-on assignment, you will add a output binding leveraging the Dapr binding building block. In the next assignment, you will implement a Dapr input binding. For detailed information, read the [introduction to this building block](https://docs.dapr.io/developing-applications/building-blocks/bindings/) in the Dapr documentation and the [bindings chapter](https://docs.microsoft.com/dotnet/architecture/dapr-for-net-developers/bindings) in the [Dapr for .NET developers](https://docs.microsoft.com/dotnet/architecture/dapr-for-net-developers/) guidance eBook.

## Success Criteria

To complete this assignment, you must reach the following goals:

- The FineCollectionService uses the Dapr SMTP output binding to send an email.
- The SMTP binding calls a development SMTP server that runs as part of the solution in a Docker container.

This assignment targets the operation labeled as **number 4** in the end-state setup:

**Local**

<img src="../images/Challenge-05/output-binding-operation.png" style="zoom: 67%;" />

**Azure**

<img src="../images/Challenge-05/output-binding-operation-azure.png" style="zoom: 67%;" />

## Tips

First open the `Resources` folder in this repo in VS Code. Then open the [Bindings documentation](https://docs.dapr.io/developing-applications/building-blocks/bindings/) and start hacking away. You can use [MailDev](https://github.com/maildev/maildev) for the development SMTP server. Then, you will bind to an Azure Logic App to send out emails.

## Learning Resources
- https://docs.dapr.io/developing-applications/building-blocks/bindings/
- https://docs.microsoft.com/dotnet/architecture/dapr-for-net-developers/bindings
- https://github.com/maildev/maildev
