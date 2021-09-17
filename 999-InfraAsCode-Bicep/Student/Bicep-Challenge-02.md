# Challenge 2 - Bicep expressions and Referencing resources

[< Previous Challenge](./Bicep-Challenge-01.md) - [Home](../README.md) - [Next Challenge>](./Bicep-Challenge-03.md)

## Introduction

In this challenge you will edit the bicep file created in Challenge 1. The goals for this challenge include:
+ Understanding Bicep expressions
    + Using Bicep functions
    + Using string interpolation
    + Using the ternary operator
+ Referencing Bicep resources

## Description

+ Instead of requiring users to provide a unique storage account name, we can use the `uniqueString()` and `resourceGroup()` functions to generate a unique storage account name. The `resourceGroup()` function returns an object containing information about the current resource group to which we are deploying.  Use the function's location property `resourceGroup().location` to access the current resource group's deployment location, instead of hard-coding it. The `uniqueString()` function takes one of more input strings  and generates a unique string using a hashing algorithm.
+ Use string interpolation to concatenate the `uniqueString()` value with a storage account prefix of your choice
+ Provide an input parameter named `globalRedundancy` of type `bool`  and use the ternary operator to switch the storage account sku name between `Standard_GRS` & `Standard_LRS` depending on whether the parameter value is `true` or `false`, respectively.
+ Create a container in the storage account you created in the previous challenge and modify the bicep file to output additional information:
    + Storage Account Name
    + Blob primary endpoint

## Success Criteria

1. You can deploy Azure Storage Account without hard-coding inputs
1. Create a container within the storage account
1. Output the storage account name and blob primary endpoint url

## Learning Resources

Learn how to "fish" for ARM template resource syntax:

- [Bicep expressions](https://github.com/Azure/bicep/blob/main/docs/tutorial/03-using-expressions.md)
- [Referencing resources](https://github.com/Azure/bicep/blob/main/docs/tutorial/04-using-symbolic-resource-name.md)- 