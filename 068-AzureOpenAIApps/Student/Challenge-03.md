# Challenge 03 - The Teachers Assistant—Batch Essay Grading

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

You can go to the data explorer for the Cosmos DB to verify that the exam submissions have loaded successfully into the **examsubmissions** collection.

The graded exams corresponding to each submission ends up in the **grades** collection in Cosmos DB

For the activity preferences for each customer uploaded, these are parsed and they end up in the **activitypreferences** Cosmos DB container.

### AI Assistants
Once you have verify that these documents have been parsed and the data has been extracted into the corresponding containers, you can use the following AI Assistants to query the database to get the answers from these data stores.

You will need to configure the assistant tools for each AI assistant to ensure that the correct function is executed when the student or parent needs to retrieve the grades for the exam submissions or when a guest needs to get recommendations for activities during their trip on the island.

- Sarah: answers questions about exams, grades and exam submissions from students.
- Priscilla: answers questions about things to do on Contoso Islands as well as make recommendations to guests based on their activity preferences.

## Success Criteria

A successfully completed solution should accomplish the following goals:

- Some files may contain multiple document types in the same file.
- The application should be able to properly classify documents and use the appropriate model to extract the submissions contained in the file
- Should be able to process all documents
- Should be able to extract all form fields from the documents
- Should be able to grade the questions for correctness.
- Should be able to store the student submission alongside the grade in JSON format in Cosmos DB
- Should be able to store the guest activity preferences in the Cosmos DB database.
- You should be able to configure the descriptions for each tool and tool parameter to enable to assistants perform their tasks correctly.
- The AI assistant should be able to parse the students responses on exam questions and grade them correctly based on the information in the knowledge (AI Search) extracted from the uploaded documents to Azure Blob Store.

## Learning Resources

https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling?tabs=python

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-model?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-classifier?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-document-intelligence-studio?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/sdk-overview-v3-1?view=doc-intel-3.1.0&tabs=csharp



## Tips
- Use Azure Cognitive Services Form Recognizer to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Use Azure Functions to orchestrate the pipeline and store the extracted information in an Azure Cosmos DB database.
- Configure the AI Assistants to answer questions from user queries
