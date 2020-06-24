# Challenge 3 - Open Some Ports

[< Previous Challenge](./ARM-Challenge-02.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-04.md)

## Introduction

The goals for this challenge include understanding:
 - variables
 - dependencies (**Hint:** Resource IDs)
 - idempotency

## Description

Extend the ARM template to add a Network Security Group that opens ports 80 and 22 and apply that rule to the subnet you created in Challenge 2.


## Success Criteria

1. Verify in the Azure portal Network Security Group has been configured as per the values specified above
1. Verify in the Azure portal that the Network Security has been applied to the subnet

## Learning Resources

- [Understanding ARM Resource IDs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#resourceid)