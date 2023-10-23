# Challenge 05 - Performance and Cost and Optimizations

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01, 02, 03 and 04 were successfully completed.

## Introduction

Making sure that the application performs and is also cost-effective is crucial to the long-term sustainability of every project.

In this challenge, we will ensure that unnecessary calls are eliminated from the application.

## Description

In this challenge, we will do the following:
- ensure that documents are only processed for embeddings if their textual contents have been updated.
- ensure that we are not processing the embeddings for the Yachts if the description of the Yacht has not been modified

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Ensure that for the updates to the Yachts, if only the pricing or capacity details are updated no embedding should be processed.


## Learning Resources

https://redis.io/docs/data-types/strings/

https://redis.io/docs/data-types/lists/

## Tips
- Compute the MD5 or SHA1 hash of the document description
- Store the hash in Redis
