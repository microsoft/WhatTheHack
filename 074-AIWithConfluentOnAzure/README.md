# What The Hack - AI With Confluent On Azure

## Introduction

This hackathon immerses you in building a real-time AI agent using **Confluent Cloud on Microsoft Azure**. You’ll learn how Confluent’s data streaming platform—based on Apache Kafka—can connect and process retail data in real time, enabling AI-driven insights that keep pace with constantly changing business conditions. Whether it’s ingesting product SKUs or synchronizing inventory levels, Confluent Cloud on Azure offers a unified, scalable, and secure platform to design near real-time pipelines and deliver accurate, intelligent solutions.

Throughout this hack, you’ll capture data from diverse sources—such as transaction logs, returns, and purchase records—and then transform or enrich that data using Apache Flink or ksqlDB. The result is an always up-to-date data backbone, ready to power AI-driven applications that swiftly respond to customer needs, supplier demands, and dynamic inventory scenarios.


## Learning Objectives

By completing this hack, you will:

- **Set up a real-time streaming environment** on Confluent Cloud in Azure, incorporating best practices for scalability, reliability, and security.  
- **Ingest and process diverse data sources** using Apache Kafka, exploring how pre-built Confluent connectors facilitate end-to-end data pipelines.  
- **Apply basic stream processing** through ksqlDB or Apache Flink to merge, filter, or aggregate event data in real time.  
- **Sync transformed data to Azure services** like Cosmos DB or Azure AI Search, ensuring your AI agent always has a near real-time view of retail operations.  
- **Lay the groundwork for AI-driven decision-making**, demonstrating how real-time data improves accuracy and responsiveness for both customers and internal stakeholders.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Prepare your Azure and Confluent Cloud environments with required infrastructure
- Challenge 01: **[Build the Flink Data Pipeline](Student/Challenge-01.md)**
	 - Create streaming data pipeline that merges multiple data streams using Apache Flink
- Challenge 02: **[Supplier Experience](Student/Challenge-02.md)**
	 - Interact with the AI agent as a supplier to query and replenish inventory
- Challenge 03: **[Customer Experience](Student/Challenge-03.md)**
	 - Simulate customer purchases and returns with real-time inventory updates
- Challenge 04: **[Employee Experience](Student/Challenge-04.md)**
	 - Access comprehensive operational insights across all transactions

## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI

## Learning Resources
- [Apache Kafka vs Confluent](https://www.confluent.io/apache-kafka-vs-confluent/)
- [What is Apache Kafka & Confluent Cloud on Azure?](https://learn.microsoft.com/en-us/azure/partner-solutions/apache-kafka-confluent-cloud/overview)
- [Create an Apache Kafka & Confluent Cloud resource](https://learn.microsoft.com/en-us/azure/partner-solutions/apache-kafka-confluent-cloud/create)
- [Confluent Hub](https://www.confluent.io/hub/)

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Terraform modules, configuration scripts, AI agent application code, and connector configurations (packaged by coach as Resources.zip)

## Contributors

- Andy Huang
- Israel Ekpo
- Juan Llovet de Casso
