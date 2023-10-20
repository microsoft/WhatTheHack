# Challenge 03 - The Teachers Assistant - Batch Essay Grading

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites (Optional)

This challenge assumes that all the dependencies in the Challenge 0 were deployed successfully.

## Introduction

Contoso Education has an Azure storage account with a Blob Store containing a large number of documents and Images of handwritten essays from students in various file formats including but not limited to PDF, PNG, TIFF and JPEG.

## Description

The goal of this challenge is to extract the mailing address, email address and phone number of the student written on the essay as well as a 300-word summary of the contents of the essay in each file. Create a pipeline that can process all the historical PDFs and PNG files stored in the blob storage.

You can use any programming language and Azure services of your choice to implement the solution. Remember to follow best practices for coding and architecture design.

Design and implement a solution for the above scenario using Azure OpenAI.

Your solution should:

- Use Azure Services to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Extract the full name, mailing address, email address and phone number of the student written on the essay from the extracted text.
- Generate a 300-word summary of the contents of the essay from the extracted text.
- Store the pipeline and store the extracted information in the Azure Cosmos DB database.
- Add error handling and logging to your solution.

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Process any PDF, PNG, TIFF and JPEG version of the submitted student essays.
- The system should grade essays using a predefined rubric.
- Successfully extract the student id, teacher id, full name, exam date, mailing address, email address and phone number of the student written on the essay.
- Successfully store the extracted information in the batch-essays collections within the students Azure Cosmos DB database.

The following fields in the batch-essays collection must be populated for each student essay that was submitted:
- StudentId
- TeacherId
- FullName
- DateOfExam
- MailingAddress (an object with the following inner fields)
  - StreetAddress
  - City
  - State
  - ZipCode
- EmailAddress
- PhoneNumber
- EssayBody

## Learning Resources

You can leverage the following resources for this challenge
- [How to generate or manipulate text](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/completions)

## Tips
- Use Azure Cognitive Services Form Recognizer to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Use Azure Cognitive Services Form Recognizer or OpenAI models to extract the mailing address, email address and phone number of the student written on the essay from the extracted text.
- Use Azure OpenAI to generate a 300-word summary of the contents of the essay from the extracted text.
- Use Azure Functions to orchestrate the pipeline and store the extracted information in an Azure Cosmos DB database.
