# Challenge 04 - Approval Process

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

Before you can use Approval Process in Power Automate, you need:
- Finish challenge 1, 2, & 3
- An account with access to Power Automate
- An Office365 Mailbox to accept incoming Order information

## Challenge

Approval Process is a Microsoft Power Automate capability you can use, without the need for coding or data science skills. This challenge involves building an end-to-end process to approve the data that was extracted in earlier challenges and have users check on the data as well as having managers approving the request other than sending emails for approvals

## Description

In this challenge, you will set up a multi-level approval process using Power Automate Flow.
All information extracted from pervious challenge should be displayed in the approval notification.
Information:
- General Order Information (Order Number, Order Date, Order Total)
- Customer Information (Full name, Address, Email or Phone)
- Order Detail Information (Product Code, Product Description, Quantity and Unit Price)
	
Based on the order total you will have different approval process.
- Under 25000 only manager approval
- Between 25000 & 100000 Manager and  Senior manager approval
- More then 100000 Senior manager & district manager approval
- Both when approver rejects or approves an email should be sent to the user. User should also be able to see if approval is pending and who is manager for then pending approval.
- Also have the pdf from challenge 2 attached to approval.


## Success Criteria

To complete this challenge successfully, you should be able to:
	· Send approval and receive a reply
	· Send approval to appropriate user 

## Learning Resources

* [Get started with Power Automate Approvals(https://docs.microsoft.com/en-us/power-automate/get-started-approvals)
* [Power Automate Modern Approvals](https://docs.microsoft.com/en-us/power-automate/modern-approvals)
* [Power Automate Approval Attachments](https://docs.microsoft.com/en-us/power-automate/approval-attachments)


