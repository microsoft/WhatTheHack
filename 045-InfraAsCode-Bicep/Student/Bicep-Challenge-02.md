# Challenge 2 - Bicep expressions and Referencing resources

[< Previous Challenge](./Bicep-Challenge-01.md) - [Home](../README.md) - [Next Challenge >](./Bicep-Challenge-03.md)

## Introduction

In this challenge you will edit the bicep file created in Challenge 1. The goals for this challenge include:

+ Understanding Bicep expressions
  + Using Bicep functions
  + Using string interpolation
  + Using the ternary operator
+ Referencing Bicep resources
+ Understanding parameter files

## Description

Bicep supports powerful functions we can use.  For example, instead of requiring users to provide a unique storage account name, we can use the `uniqueString()` and `resourceGroup()` functions to generate a unique storage account name. The `resourceGroup()` function returns an object containing information about the current resource group to which we are deploying.  

## Challenges

**Challenge**: Use the function's location property `resourceGroup().location` to access the current resource group's deployment location, instead of hard-coding it. The `uniqueString()` function takes one of more input strings  and generates a unique string using a hashing algorithm.

**Challenge**: Use string interpolation to concatenate the `uniqueString()` value with a storage account prefix of your choice to create a unique storage account name

**Challenge**: Provide an input parameter named `geoRedundancy` of type `bool` and use the [ternary operator](https://learn.microsoft.com/azure/azure-resource-manager/bicep/operators#operator-precedence-and-associativity) to switch the storage account sku name between `Standard_GRS` & `Standard_LRS` depending on whether the parameter value is `true` or `false`, respectively.

**Challenge**: Create a container in your storage account and modify the Bicep file to output additional information:

- Storage Account Name
- Blob primary endpoint

**Challenge:** In Challenge 01, you observed that parameter values need to be passed in via the command line or you will be prompted for their values each time you deploy the template. Use a parameter file to list parameter values and pass them into the template.

**NOTE:** Bicep uses the same parameter file format (JSON) as ARM Templates

## Success Criteria

1. You can pass parameter values to the template via a parameter file
1. You can deploy Azure Storage Account without hard-coding inputs
1. Create a container within the storage account
1. Output the storage account name and blob primary endpoint url

## Learning Resources

+ [String functions for Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-string)
+ [Parameter files](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameter-files)
