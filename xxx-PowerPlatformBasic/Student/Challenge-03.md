# Challenge 03 - Extracting Order Data Using AI Builder

## Pre-requisites

	· An account with access to Power Automate
	· A trained AI Builder model or an AI Builder prebuilt model.

## Introduction

AI Builder is a Microsoft Power Platform capability you can use to bring the power of Microsoft AI to your organization, without the need for coding or data science skills. This challenge involves building an end-to-end process to extract key Order Data from an Order in PDF/Image/Word format to help automate the processing of Orders.

## Description

In this challenge, you will set up a Model to extract data from a sample Order form so we can use it in the Power Automate Flow.
You can find the sample Order Form in the Challenge3 folder of the Resources.zip file provided by your coach.
Review the sample Order Document and decide whether we can use any prebuilt model that AI Builder offers, or we need to build a custom model to read the information on the form.
The Model is required to:
	· Extract General Order Information (Order Number, Order Date, Order Total)
	· Extract Customer Information (Full name, Address, Email or Phone)
	· Extract Order Detail Information (Product Code, Product Description, Quantity and Unit Price)
	
Once the model is set up properly and extracted information as expected, integrate this model into the Power Automate Flow that you built in challenge 2.
	· Save the information of Order and Customer extracted from PDF into Order Table
	· Save the information of Order Detail extracted from PDF to Order Line Item Table
	· Maintain the relationship between Order and Order Line Item

## Success Criteria

	· Verify that the Model extracts information from the Order form properly
	· Demonstrate that the Model can be integrated with Power Automate flow that we built in Challenge 2

## Learning Resources

	· AI models and business scenarios - AI Builder | Microsoft Docs
	· Invoice processing prebuilt AI model - AI Builder | Microsoft Docs
	· Overview of document processing model - AI Builder | Microsoft Docs
	· Use the document processing model in Power Automate - AI Builder | Microsoft Docs
	· Use the form processor component in Power Apps - AI Builder | Microsoft Docs

## Advanced Challenges

Too comfortable? Eager to do more? Try these additional challenges!
	· Handle Exception Cases (What if the model extracting data incorrectly).
	· Try to use the AI Model that extracts Order Information in Power Apps Canvas App
	· Explore the Document automation toolkit - AI Builder | Microsoft Docs

## Note

Link to Order PDF Sample in What The Hack Team's site
https://microsoft.sharepoint.com/:f:/t/wth/EhBumzUu7V5Ln5YfOtEHqyoBOwvpMURwBprRaymEKebQww?e=gMWGYc
