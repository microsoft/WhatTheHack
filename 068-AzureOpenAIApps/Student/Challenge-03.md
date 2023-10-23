# Challenge 03—The Teachers Assistant—Batch Essay Grading

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01 were successfully completed.

## Introduction

Contoso Education has an Azure storage account with a Blob Store containing a large number of documents and Images of handwritten essays from students in various file formats including but not limited to PDF, PNG, TIFF and JPEG.

## Description

The goal of this challenge is to extract the school district, school name, student id, student name and question answers from civics/social studies exams from students in the country.

Your goal is to design and create a pipeline that can process all the historical PDFs and PNG files for these exams stored in the blob storage.

You can use any programming language and Azure services of your choice to implement the solution. Remember to follow best practices for coding and architecture design.

Design and implement a solution for the above scenario using Azure OpenAI.

Your solution should:

- Use Azure Services to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Extract the full name, mailing address, email address and phone number of the student written on the essay from the extracted text.
- Store the pipeline and store the extracted information in the Azure Service Bus queues in JSON format.
- Pick up the extracted JSON documents from Azure Service Bus and grade the exams for correctness for each answer provided.
- Store the grade in JSON format in Cosmos DB for each student submission. The grade should be a score between 0 and 100. All questions carry equal weight.
- Add error handling and logging to your solution.

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Some files may contain multiple document types in the same file.
- The application should be able to properly classify documents and use the appropriate model to extract the submissions contained in the file
- Should be able to process all documents
- Should be able to extract all form fields from the documents
- Should be able to grade the questions for correctness.
- Should be able to store the student submission alongside the grade in JSON format in Cosmos DB


## Learning Resources

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-model?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-classifier?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-document-intelligence-studio?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/sdk-overview-v3-1?view=doc-intel-3.1.0&tabs=csharp

https://redis.io/docs/data-types/strings/

https://redis.io/docs/data-types/lists/


## Tips
- Use Azure Cognitive Services Form Recognizer to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Use Azure Functions to orchestrate the pipeline and store the extracted information in an Azure Cosmos DB database.
