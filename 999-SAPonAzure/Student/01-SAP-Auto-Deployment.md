# Challenge 1: Update 01-SAP-Auto-Deployment.

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-Azure-Monitor.md)

## Introduction

This document introduces an automation tool for SAP Basis persons on provision of (1) all necessary Azure infrastructure (compute/storage/network) (2) server configurations and SAP system installation. The tool is based on Terraform and Ansible script.

## Description

During the exercise, participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP S4H system by using an existing backup files into this environment as shown in the following diagram. SAP HANA DB will use Azure Netapp Filesystem for storage volume. 

![image](https://user-images.githubusercontent.com/73615525/115279764-f99d4080-a0fb-11eb-9e56-d43ee96fe173.png)

## Success Criteria

1.	Complete build of SAP S4H and SAP HANA database on Azure Cloud.
2.	Successful Installation of SAP GUI and test logon to SAP Application Server

## Learning Resources

[SAP GUI Installation Guide](https://help.sap.com/viewer/1ebe3120fd734f67afc57b979c3e2d46/760.05/en-US)

[SAP HANA studio installation guide](https://help.sap.com/viewer/a2a49126a5c546a9864aae22c05c3d0e/2.0.01/en-US)
