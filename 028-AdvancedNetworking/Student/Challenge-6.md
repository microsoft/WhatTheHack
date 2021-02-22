
# Challenge 6 - Azure Bastion

[< Previous Challenge](./Challenge-5.md) - [Home](../README.md) - [Next Challenge>](./Challenge-7.md)


<br />

## Introduction

In this challenge, you will learn how to securely provide management access to your Azure environment.

<br />

## Description

Contoso wants to provide a more secure way to access the servers in Azure. Contoso's IT administrators and application developers need to be able to access and manage the servers remotely from anywhere. Opening up all the servers to the internet is not a desired solution. Contoso is looking for a robust managed solution that prevents the need to open up management ports on the virtual machines to the internet while also improving protection against zero day exploits. Security team should be able to audit access to resources in the subscription.

For this challenge:

- Enable a secure way to access the virtual machines.

- All virtual machines in the Payments and Finance servers should be accessed privately.


<br />

## Success Criteria

- Servers should not have direct RDP and SSH access from the internet.

- You should be able to view active connections.

- Audit logs should be available to view.

<br />

## Learning Resources

[Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
