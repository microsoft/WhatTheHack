# Challenge 03 - The Teachers Assistant—Batch Essay Grading

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites (Optional)

This challenge assumes that all requirements for Challenges 01 were successfully completed.

## Introduction

Contoso Education has an Azure storage account with a Blob Store containing a large number of documents and Images of handwritten essays from students in various file formats including but not limited to PDF, PNG, TIFF and JPEG.

## Description

The goal of this challenge is to extract the school district, school name, student id, student name and question answers from civics/social studies exams from students in the country. You will also need to parse the activity preferences and advance requests from the tourists visiting Contoso Islands.

Your goal is to design and create a pipeline that can process all the historical PDFs and PNG files for these exam submissions and activity preferences stored in the blob storage.

You can use any programming language and Azure services of your choice to implement the solution. Remember to follow best practices for coding and architecture design.

There are 20 sample documents in the  **Student/Resources/Challenge-00/ContosoAIAppsBackend/challenge-artifacts/contoso-education** folder:

- F01-Civics-Geography and Climate
- F02-Civics-Tourism and Economy
- F03-Civics-Government and Politics
- F04-Activity-Preferences

Each folder containers 5 samples you will use for training the custom classifier and extractor.

You will need to create a container in Azure Blob Store called **classifications** and then upload 5 document samples each from the following folders into the **classifications** container in Blob Store. There should be a total of 20 samples from the 4 classes or categories inside the **classifications** container in Blob Store.

At runtime in the automated data pipeline, the app will invoke the custom classifier from Azure Document Intelligence to recognize which document type it has encountered and then it will call the corresponding custom extractor model to parse the document and extract the relevant fields.

## Creating a Custom Classifier Model in Document Intelligence Studio

You will need to create one Classifier Project which will give you one Classification Model to process the 4 different types of documents we have. When you create your Model, make sure the name matches the value of the **DOCUMENT_INTELLIGENCE_CLASSIFIER_MODEL_ID** setting in your applications settings config file. <BR>

Note: You may need to use the Settings icon in the Azure Portal to switch directories if your Entra ID belongs to more than one Azure tenant.

The custom classifier helps you to automate the recognition of the different document types or classes in your knowledge store

Use these directions for [Buidling a Custom Classifier Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-classifier?view=doc-intel-4.0.0) to train the custom classifier in Azure Document Intelligence on how to recognize the following 4 categories of documents:
- f01-geography-climate 
- f02-tourism-economy
- f03-geography-politics
- f04-activity-preferences

When creating your model identifiers please ensure that you use these names as the model ids. If you use a different value for each document type, please update your **document-intelligence-dictionary.json** configuration file for your application accordingly. Ensure that the **classifier_document_type** in your dictionary configuration matches what you have in your Document Intelligence Studio.

## Create a Custom Neural Extraction Model in the Document Intelligence Studio

Use these directions for [Building a Custom Extractor Model](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/compose-custom-models?view=doc-intel-4.0.0&tabs=studio) to build and train each of the extractor models for the 4 document types. You will need 4 projects (1 for each category of documents that references each Azure Blob storage container listed above). 

Make sure that the **extractor_model_name** field in your application config **document-intelligence-dictionary.json** matches what you have in Document Intelligence Studio
- f01-extractor-model
- f02-extractor-model
- f03-extractor-model
- f04-extractor-model

Also ensure that the field names such as **q1** and **q5** matches exactly what you have in Document Intelligence Studio.

The first 3 extractor models a straightforward. However in the 4th document type, we have tables, signatures and checkboxes.

#### **document-intelligence-dictionary.json** 
````json
[
{
    "classifier_document_type": "f03-geography-politics",
    "extractor_model_name": "f03-extractor",
    "model_description": "This is used to extract the contents of Form 03 using Azure Doc Intelligence",
    "fields": {
      "student_id": "student_id",
      "student_name": "student_name",
      "school_district": "school_district",
      "school_name": "school_name",
      "exam_date": "exam_date",
      "question_1": "q1",
      "question_2": "q2",
      "question_3": "q3",
      "question_4": "q4",
      "question_5": "q5"
    }
  },
  {
    "classifier_document_type": "f04-activity-preferences",
    "extractor_model_name": "f04-extractor2",
    "model_description": "This is used to extract the contents of Form 04 (Activity Preferences) using Azure Doc Intelligence",
    "fields": {
      "guest_full_name": "guest_full_name",
      "guest_email_address": "email_address",
      "checkbox_contoso_floating_museums": "contoso_floating_museums",
      "checkbox_contoso_solar_yachts": "contoso_solar_yachts",
      "checkbox_contoso_beachfront_spa": "contoso_beachfront_spa",
      "checkbox_contoso_dolphin_turtle_tour": "contoso_dolphin_turtle_tour",
      "table_name": "activity_requests",
      "table_column_header_experience_name": "experience_name",
      "table_column_header_preferred_time": "preferred_time",
      "table_column_header_party_size": "party_size",
      "signature_field_name": "guest_signature",
      "signature_date_field_name": "signature_date"
    }
  }
]
````


Your solution should:

- Use Azure Services to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- For the exam submissions, extract the full name and profile details and answers to each exam question and store the extract fields in Cosmos DB.
- The the tourists' travel and acvity preferences, extract the profile data and activity preferences of the guest and store the extracted data in Cosmos DB
- Use Azure Service Bus to throttle high traffic scenarios.
- Pick up the extracted JSON documents from Azure Service Bus and grade the exams for correctness for each answer provided using the LLMs.
- Store the procesed grade in JSON format in Cosmos DB for each student submission. The grade should be a score between 0 and 100. All questions carry equal weight.
- Add error handling and logging to your solution.

You can go to the data explorer for the Cosmos DB to verify that the exam submissions have loaded successfully into the **examsubmissions** collection.

The graded exams corresponding to each submission ends up in the **grades** collection in Cosmos DB

For the activity preferences for each customer uploaded, these are parsed and they end up in the **activitypreferences** Cosmos DB container.

### Student Records

Just like how you uploaded yacht records and modified the yacht records via the http client, use the **rest-api-students-management.http** http client to upload student records to Cosmos DB. The AI assistant will only respond to queries from students registered in the Comsos DB database.

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

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/project-share-custom-models?view=doc-intel-4.0.0

https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/function-calling?tabs=python

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-model?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/build-a-custom-classifier?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/concept-document-intelligence-studio?view=doc-intel-3.1.0

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/sdk-overview-v3-1?view=doc-intel-3.1.0&tabs=csharp

https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/how-to-guides/project-share-custom-models?view=doc-intel-4.0.0



## Tips
- Use Azure Cognitive Services Form Recognizer to extract the text from the PDF, PNG, TIFF and JPEG files stored in the blob storage.
- Use Azure Functions to orchestrate the pipeline and store the extracted information in an Azure Cosmos DB database.
- Configure the AI Assistants to answer questions from user queries
