# Challenge 03 - Advanced Resource Declarations

[< Previous Challenge](./Challenge-02.md) - [Home](../README.md) - [Next Challenge >](./Challenge-04.md)

## Introduction

The goals for this challenge include understanding:

- How to reference to an existing resource
- Creating a set of resources based on a list or count (loops)

## Description

Create a new Bicep file that adds additional blob containers to an already existing storage account created in previous challenges

- You should declare a storage account by referencing an already `existing` storage account created in the earlier challenges. The file must not contain a full declaration of the storage account.
- The Bicep file will take an array of strings representing container names as an input and use a `for loop` to create containers in the list within the existing storage account.

## Success Criteria

1. Use the Azure portal to verify new containers were added to the storage account.
