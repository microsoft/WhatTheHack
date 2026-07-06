# What The Hack - Confluent Cloud Integration with Microsoft Azure

## Introduction

This introductory hackathon will provide participants with hands-on experience on how to integrate the Confluent Cloud offering with Microsoft Azure platform services.

## Learning Objectives

The objective of the hackathon is to demonstrate different strategies for integrating Confluent Cloud on Azure with Azure Platform products across various scenarios.

## Exit Competencies
Upon completion, the participants should be able to:
- Master basic concepts involved with event stream processing with Confluent Cloud leveraging the Apache Kafka Ecosystem components such as Producers, Consumers, Kafka Connect, Kafka Streams, KSQL and Schema Registry.
- Understand the different source and sink connectors available for integration on Microsoft Azure.
- Provision and configure Confluent Cloud and the various ecosystem components.
- Secure access to Confluent Cloud Resources.
- Integrate Azure Private Virtual Networks with Confluent Cloud
- Perform capacity planning and quota enforcement for Confluent Cloud resources.
- Manage availability, business continuity and disaster recovery.

## Challenges

These are the 5 challenges for the Hack.
- Challenge 00: **[ Prerequisites, Sizing & Capacity Planning](Student/Challenge-00.md)**
	 - Prepare your workstation to work with Azure. Deploy the Confluent & Azure resources needed for starting the Hack.
- Challenge 01: **[Data Definition and Core Concepts for Storage](Student/Challenge-01.md)**
	 - DDL: Design, configure and create Kafka topics and Schema Registry instance for the Kafka events/messages.
- Challenge 02: **[Data Manipulation Reading and Writing Data Directly with Topics](Student/Challenge-02.md)**
	 - DML: Write data from Kafka producers and read data with Kafka consumers. Enrich and display events coming back from Kafka topics.
- Challenge 03: **[Kafka Connect Ecosystem and Architecture](Student/Challenge-03.md)**
	 - The glue: leverage the Kafka Connect ecosystem to bring data into Kafka topics from different data stores and write events out to different data stores using Kafka Connect.
- Challenge 04: **[Bringing it All Together, Processing Streams in Realtime with KSQLDB](Student/Challenge-04.md)**
	 - Real-time JOINS: Leverage Kafka Streams and KSQLDB to bring together multiple streams of events, facts and dimensions to enrich, filter, process and generate new events from existing streams.
- Challenge 05: **[Realtime Visualization of Streams](Student/Challenge-05.md)**
	 - A picture is worth 1024 words. Generate cool visualizations that captures the state of the streams in realtime.

## Prerequisites

- Access to an Azure subscription with Owner access
	- If you don’t have one, Sign Up for Azure [HERE](https://azure.microsoft.com/en-us/free/)
	- Familiarity with [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview#multiple-access-points)
- Access to [Confluent Cloud on Azure](https://learn.microsoft.com/en-us/azure/partner-solutions/apache-kafka-confluent-cloud/overview), an Azure Native ISV Services
- An IDE: [Visual Studio Code](https://code.visualstudio.com/), [WebStorm](https://www.jetbrains.com/webstorm/download/), [PyCharm](https://www.jetbrains.com/pycharm/download/) or [IntelliJ](https://www.jetbrains.com/idea/download/)

## Contributors

- [Israel Ekpo](https://github.com/izzymsft)
- [Jacob Bogie](https://github.com/JakeBogie)
