# Challenge 2 - Bicep expressions and Referencing resources

[< Previous Challenge](./Bicep-Challenge-01.md) - [Home](../README.md) - [Next Challenge>](./Bicep-Challenge-03.md)

## Introduction

In this challenge you will edit the bicep file created in Challenge 1. The goals for this challenge include:
+ Understanding Bicep expressions
    + Using Bicep functions
    + Using string interpolation
    + Using the ternary operator
+ Referencing Bicep resources
+ Understanding parameter files

## Description

+ Instead of requiring users to provide a unique storage account name, we can use the `uniqueString()` and `resourceGroup()` functions to generate a unique storage account name. The `resourceGroup()` function returns an object containing information about the current resource group to which we are deploying.  Use the function's location property `resourceGroup().location` to access the current resource group's deployment location, instead of hard-coding it. The `uniqueString()` function takes one of more input strings  and generates a unique string using a hashing algorithm.
+ Use string interpolation to concatenate the `uniqueString()` value with a storage account prefix of your choice
+ Provide an input parameter named `globalRedundancy` of type `bool`  and use the ternary operator to switch the storage account sku name between `Standard_GRS` & `Standard_LRS` depending on whether the parameter value is `true` or `false`, respectively.
+ Create a container in the storage account you created in the previous challenge and modify the bicep file to output additional information:
    + Storage Account Name
    + Blob primary endpoint
+ In the previous challenge, you observed that parameter values need to be passed in via the command line or you will be prompted for their values each time you deploy the template. Use a parameter file to list parameter values and pass them into the template.

**NOTE:** ARM Templates with Bicep use the same parameter file format as ARM Templates with JSON. 

## Success Criteria

1. You can pass parameter values to the template via a parameter file
1. You can deploy Azure Storage Account without hard-coding inputs
1. Create a container within the storage account
1. Output the storage account name and blob primary endpoint url


