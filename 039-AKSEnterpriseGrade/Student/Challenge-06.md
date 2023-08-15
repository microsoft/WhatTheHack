# Challenge 06 - Persistent Storage in AKS

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

This challenge will cover the basics of Kubernetes persistent volumes.

## Description

You need to fulfill these requirements to complete this challenge:

- The API pods should access a database deployed in the Kubernetes cluster using persistent volumes
- The container cluster should be spread across multiple Availability Zones
- Find out the maximum performance (IOPS and MB/s) that the database will be able to support with the storage class you chose

## Success Criteria

- The database has been deployed in the cluster, and the API pod can connect to it (read its version)
- Participants can demonstrate I/O performance of at least two storage classes

## Learning Resources

These docs might help you achieving these objectives:

- [SQL Server on AKS](https://docs.microsoft.com/sql/linux/tutorial-sql-server-containers-kubernetes)
- [Storage in AKS](https://docs.microsoft.com/azure/aks/concepts-storage)