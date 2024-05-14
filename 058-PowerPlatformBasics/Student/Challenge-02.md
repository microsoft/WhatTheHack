# Challenge 02 - Build an AI Model to Extract Order Data

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

- Test your login to access Power Automate at: https://make.powerautomate.com and select your country
- You may be prompted to start a free trial of AI Builder

## Introduction

AI Builder is a Microsoft Power Platform capability you can use to bring the power of Microsoft AI to your organization, without the need for coding or data science skills. This challenge involves building an end-to-end process to extract key Order Data from an Order in PDF/Image/Word format to help automate the processing of Orders. 

## Description

In this challenge, you will set up a Model to extract data from a sample Order form so we can use it in the Power Automate Flow.

You can find the sample Order Form in the `/TailspinToysOrders/` folder of the student `Resources.zip` file provided by your coach

Review the sample Order Document and decide whether we can use any prebuilt model that AI Builder offers, or we need to build a custom model to read the information on the form.

The Model is required to:
- Extract General Order Information (Order Number, Order Date and Order Total)
- Extract Customer Information (Full name, Address, and Phone)
- Extract Order Detail Information (Product Code, Product Description, Quantity and Unit Price)

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the Model extracts information from the Order form properly

## Learning Resources

* [AI Builder Model](https://docs.microsoft.com/en-us/ai-builder/build-model)
* [Pre-built model](https://docs.microsoft.com/en-us/ai-builder/prebuilt-overview)
* [Get Started with Power Automate](https://docs.microsoft.com/en-us/learn/modules/get-started-flows/)
* [AI models and business scenarios - AI Builder](https://docs.microsoft.com/en-us/ai-builder/model-types)
* [Invoice processing prebuilt AI model - AI Builder](https://docs.microsoft.com/en-us/ai-builder/prebuilt-invoice-processing)
* [Overview of document processing model - AI Builder](https://docs.microsoft.com/en-us/ai-builder/form-processing-model-overview)
* [Use the document processing model in Power Automate - AI Builder](https://docs.microsoft.com/en-us/ai-builder/form-processing-model-in-flow)
* [Use the form processor component in Power Apps - AI Builder](https://docs.microsoft.com/en-us/ai-builder/form-processor-component-in-powerapps)
