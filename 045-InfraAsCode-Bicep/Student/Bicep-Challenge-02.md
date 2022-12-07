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

Bicep supports the use of functions in a template. Functions return information that can be set as the value of a parameter or a variable. Some functions take input parameters.  Other functions can return information about an object or its properties.

In the previous challenge, you defined and accepted two parameters for your Bicep template:
- location
- storageAccountName

Instead of requiring users of your Bicep template to provide these values, we can use Bicep functions to provide these values dynamically when the template is run.

Bicep has two functions that can help here:
- `uniqueString()`
- `resourceGroup()`

The `resourceGroup()` function returns an object containing information about the current Azure Resource Group to which the template is being deployed.

The `uniqueString()` function takes one or more input strings and generates a unique string value using a hashing algorithm.

- Use the `resourceGroup()` function's `location` property to access the current resource group's location, and then use it for the default value of the location parameter instead of depending on a user to pass it in.

- Use the `uniqueString()` and `resourceGroup()` functions to generate a unique storage account name.
- Use string interpolation to concatenate the `uniqueString()` value with a storage account prefix of your choice (i.e. your initials)

**NOTE:** Storage account names must be unique. They must contain 3 or more characters and be all lowercase. 

- Provide an input parameter named `globalRedundancy` of type `bool`  and use the ternary operator to switch the storage account sku name between `Standard_GRS` & `Standard_LRS` depending on whether the parameter value is `true` or `false`, respectively.
- Create a container in the storage account you created in the previous challenge and modify the bicep file to output additional information:
    - Storage Account Name
    - Blob primary endpoint
- In the previous challenge, you observed that parameter values need to be passed in via the command line or you will be prompted for their values each time you deploy the template. Use a parameter file to list parameter values and pass them into the template.

**NOTE:** ARM Templates with Bicep use the same parameter file format as ARM Templates with JSON. 

## Success Criteria

1. You can pass parameter values to the template via a parameter file
1. You can deploy Azure Storage Account without hard-coding inputs
1. Create a container within the storage account
1. Output the storage account name and blob primary endpoint url


