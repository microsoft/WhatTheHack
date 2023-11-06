# Challenge 03: Godzilla takes out an Azure region!

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Pre-requisites

Before creating your Azure Chaos Studio Experiment, ensure you have deployed and verified the pizzeria application is available in both regions (EastUS
and WestUS)

## Introduction

Welcome to Challenge 3. 

Can your application survive a region failure?

So far you have tested failures with Contoso Pizza's AKS pod(s), AKS node(s), and now it is time to test failures at the regional
level. 

As Contoso Pizza is a national pizza chain, hungry people all over the United States are ordering pizzas and watching the Super
Bowl. Enter Godzilla! He exists! He is hungry! He is upset (hangry)! He is going to destroy the WestUS! What will your application
do? 
 

## Description

As the purpose of this WTH is to demonstrate Chaos Studio, we are going to simulate a region failure. As you have deployed the pizzeria application in 2 regions
(EastUS/WestUS). As we are hacking on Azure's Chaos Studio, we are pretending the databases are in sync, and we are showing how Chaos Studio can simulate
the failure of a region.   

- Create an Azure Chaos Studio's Experiment(s) that can simulate a region failure

During the experiment, were you able to order a pizza? If not, what could you do to make your application more resilient


## Success Criteria

- Verify the experiment is running
- Show any failure you observed during the experiment
- Verify application is available after WestUS region is offline
- Verify all application traffic is routing to the surviving region

## Tips

-  Think of the multiple ways to simulate a region failure 
-  Did you create the NSG from Challenge 0? 
-  Use [GeoPeeker](https://geopeeker.com/home/default) to verify traffic routing


## Learning Resources

- [Azure Traffic Manager](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-configure-priority-routing-method)
- [Azure Traffic Manager endpoint monitoring](https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-monitoring)

