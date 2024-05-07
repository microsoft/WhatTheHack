# Challenge 05 - Performance and Cost and Optimizations

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** 

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01, 02, 03 and 04 were successfully completed.

## Introduction

Making sure that the application performs and is also cost-effective is crucial to the long-term sustainability of every project.

In this challenge, we will ensure that unnecessary calls are eliminated from the application.

This is accomplished by keeping a copy of the document or description contents' SHA1 in memory and comparing it to subsequent receipts to ensure that we only compute the embedding if the text contents have been modified.

## Description

In this challenge, we will do the following:

- ensure that documents are only processed for embeddings if their textual contents have been updated.
- ensure that we are not processing the embeddings for the Yachts if the description of the Yacht has not been modified

Ensure that the **COMPUTE_EMBEDDINGS_ONLY_IF_NECESSARY** application setting local.settings.json is set to 0

When this value is set to Zero, embeddings are computed regardless of whether the text contents have been modified.
When it is set to One, embeddings are only calulated if the text contents have been updated.

The application solves this by maintaing a copy of the document or description contents' SHA1 HASH in memory and comparing it to subsequent receipts of similar content for the same record or document to ensure that we only compute the embedding if the text contents have been modified.

## Verification

Using the HTTP client, make changes to each yacht price and maxCapacity fields and save the changes.
Using the file uploader, re-upload all the files to the government blob container AS IS without making any changes.

In app insights, you should see the following events registered for each document filename and yacht id you have modified respectively:
- **PROCESS_DOCUMENT_EMBEDDING_COMPUTE**
- **PROCESS_YACHT_EMBEDDING_COMPUTE**

After this has been verified,  updated **COMPUTE_EMBEDDINGS_ONLY_IF_NECESSARY** application setting is set to 1

Using the HTTP client, make changes to each yacht price and maxCapacity fields and save the changes.
Using the file uploader, re-upload all the files to the government blob container AS IS without making any changes.

![Application Insights](../images/app-insights.png)

In app insights, you should see the following events registered for each document and yacht you have modified respectively:
- **SKIP_YACHT_EMBEDDING_COMPUTE**
- **SKIP_DOCUMENT_EMBEDDING_COMPUTE**

This means that the embedding was only computed if the yacht description or text content of the documents were modified.

Using the HTTP client, make changes to each yacht description fields and save the changes.
Using the file uploader, re-upload all the files to the government blob container with minor punctuation (commas, paragraphs, periods) and save the changes and reupload.

In app insights, you should see the following events registered for each document and yacht you have modified respectively:
- **PROCESS_DOCUMENT_EMBEDDING_COMPUTE**
- **PROCESS_YACHT_EMBEDDING_COMPUTE**

You should also be able to see the hashes in the Redis Cache

````bash

# Run this to see all the keys in the Cache
SCAN 0 COUNT 1000 MATCH *

# Run this for each key to retrieve the value
GET {key}
GET yacht_embeddings_cache_400
GET document_embeddings_cache_government/definition.txt

````

![Application Insights](../images/redis-embeddings.png)

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Ensure that for the updates to the Yachts, if only the pricing or capacity details are updated no embedding should be processed.
- Ensure that for documents, the embeddings are only computed if the text contents were modified.


## Learning Resources

https://redis.io/docs/data-types/strings/
https://redis.io/docs/data-types/lists/

## Tips
- Compute the MD5 or SHA1 hash of the document description
- Store the hash in Redis
