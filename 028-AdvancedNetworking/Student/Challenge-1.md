

# Challenge 1 - Virtual Networks

[Home](../README.md) - [Next Challenge >](./Challenge-2.md)

<br />

## Pre-requisites

Before you start this challenge, ensure you have the following setup and access:

- Access to an Azure subscription.

- Account to access Azure portal or Azure CLI.

<br />

## Introduction

In this challenge, you will learn how to design and deploy Azure virtual networks.

<br />

## Description

Contoso Inc. has decided to move their infrastructure to cloud. They will start with moving applications from two business units to cloud.

The Payment Solutions department will plan for a three tier architecture for their business applications. The finance unit has internal applications that do not need to be accessed from the internet. These applications need to be isolated from other business units. The applications deployed in Azure will communicate with the servers deployed on-premises. The on-premises data center uses network range 10.128.0.0/9.

<br />

For this challenge:

1. Create a virtual network for the Payments Processing department. Add two subnets, one for web servers and one for app servers.

2. Create another virtual network for the Finance department with one subnet.

3. Plan IP addressing for the Azure environment to meet the above requirements.

<br />

## Success Criteria

- You should have planned IP addressing for your virtual networks.

- Successfully provisioned isolated environments for Payment Solutions and Finance departments.

<br />

## Learning Resources

[Virtual network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)

[Virtual Network Best Practices](https://docs.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices)
