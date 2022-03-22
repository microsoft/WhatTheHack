# What The Hack - Azure Migrate

## Introduction

In this hack, you will learn how to assess and migrate a multi-tier application from Hyper-V to Azure. You will learn how to use Azure Migrate as the hub for executing a migration, together with accompanying tools.

## Learning Objectives

After this hack you will know the role of Azure Migrate and related migration tools and how to use them to successfully migrate an on-premises multi-tier application to Azure.

The estimated time required to complete the core objectives of this hack is 1 day however there are some additional "stretch" goals available, should you wish to undertake them.

## Before you start

Before the hack begins, an on-premises infrastructure hosted in Hyper-V will have been deployed for you. This infrastructure is hosting a multi-tier application called 'SmartHotel', using Hyper-V VMs for each of the application tiers.

During the lab, you will migrate this entire application stack to Azure. This will include assessing the on-premises application using Azure Migrate and migrating the web and application tiers using Azure Migrate: Server Migration. This step includes migration of both Windows and Linux VMs.

As stretch goals, you can undertake assessment of the database tier using Microsoft Data Migration Assistant (DMA) and a migration of the database to a PaaS solution using the Azure Database Migration Service (DMS)

## Challenges

- Challenge 0: **[Environment Setup](./Student/00-lab_setup.md)**
    - Deploy the required infrastructure for the exercises
- Challenge 1: **[Design and Planning](./Student/01-design.md)**
    - Plan your migration
- Challenge 2: **[Discovery and Assessment](./Student/02-discovery.md)**
    - Discover your digital estate
- Challenge 3: **[Prepare the Migration](./Student/03-prepare.md)**
    - Replicate workloads to Azure and test migration
- Challenge 4: **[Execute the Migration](./Student/04-migrate.md)**
    - Move workloads from on-premises to Azure
- Challenge 5: **[Modernization](./Student/05-modernise.md)**
    - Modernise your workloads with Azure PaaS services

## Prerequisites

- This challenge does not have any technical prerequisite. Azure Virtual Machines knowledge and basic understanding of Windows is required though

## Contributors

- Emily McLaren
- Barney Gwyther
- Jose Moreno
