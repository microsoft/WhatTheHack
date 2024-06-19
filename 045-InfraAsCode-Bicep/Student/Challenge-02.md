# Challenge 02 - Bicep Expressions and Referencing Resources

[< Previous Challenge](./Challenge-01.md) - [Home](../README.md) - [Next Challenge >](./Challenge-03.md)

## Introduction

In this challenge you will edit the Bicep file created in Challenge 1. The goals for this challenge include:
- Understanding Bicep expressions
    - Using Bicep functions
    - Using string interpolation
    - Using the ternary operator
- Referencing Bicep resources
- Understanding parameter files

## Description

### Bicep Functions

Bicep supports powerful functions we can use. Functions return information that can be set as the value of a parameter or a variable. Some functions take input parameters.  Other functions can return information about an object or its properties.

In the previous challenge, you defined and accepted two parameters for your Bicep template:
- location
- storageAccountName

Instead of requiring users of your Bicep template to provide these values, we can use Bicep functions to provide these values dynamically when the template is run.

Bicep has two functions that can help here:
- `resourceGroup()` - This function returns an object containing information about the current Azure Resource Group to which the template is being deployed.
- `uniqueString()` - This function takes one or more input strings and generates a unique string value using a hashing algorithm.

Using functions, ensure the `location` and `storageAccountName` properties can be set dynamically as follows:

- Use the `resourceGroup()` function's `location` property to access the current resource group's location, and then use it for the default value of the location parameter instead of depending on a user to pass it in.
- Use the `uniqueString()` and `resourceGroup()` functions to generate a unique storage account name.
- Use string interpolation to concatenate the `uniqueString()` value with a storage account prefix of your choice (i.e. your initials)

  **NOTE:** Storage account names must be unique. They must contain 3 or more characters and be all lowercase. 

### Bicep Operators

Like other programming languages, Bicep supports the use of Operators. Operators are used to calculate values, compare values, or evaluate conditions. 

Bicep's ternary operator is a clever way to simplify the syntax needed to do comparisons. Use it manage the redundancy of the storage account as specified:

- Provide an input parameter named `globalRedundancy` of type `bool` and use the ternary operator to switch the storage account sku name between `Standard_GRS` & `Standard_LRS` depending on whether the parameter value is `true` or `false`, respectively.

### Reference Existing Bicep Resources

When authoring a Bicep template, it is common that you will need to get a reference to another Azure resource so that you can either modify it, or retreive properties from it.

For example, when defining Virtual Network (VNET), you may want to configure a Network Security Group (NSG) to apply to a subnet. In this scenario, the VNET resource will need a reference to the NSG resource.

In ARM Templates with JSON, this was a complicated task. Bicep makes referencing an existing resource SO much easier!

And now you will need to figure it out by doing the following:

- Create a container in the storage account you created in the previous challenge and modify the bicep file to output additional information:
    - Storage Account Name
    - Blob primary endpoint

### Bicep Parameter Files

In the previous challenge, you observed that parameter values need to be passed in via the command line or you will be prompted for their values each time you deploy the template. 
- Use a parameter file to list parameter values and pass them into the template.

**HINT:** Bicep uses the same parameter file format as ARM Templates with JSON. 

## Success Criteria

1. Verify you can pass parameter values to the template via a parameter file
1. Demonstrate that you can deploy Azure Storage Account without hard-coding inputs
1. Verify you can create a container within the storage account
1. Verify you can output the storage account name and blob primary endpoint url

## Learning Resources

- [Bicep Operators](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/operators)
- [String functions for Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-string)
- [Bicep Parameter files](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameter-files)
