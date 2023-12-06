# Challenge 04 - Approval Process

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

Approval Processing is a Microsoft Power Automate capability you can use without the need for coding or data science skills. This challenge involves building an end-to-end process to approve the data that was extracted in the earlier challenges and have users review the data as well as having managers efficiantly approving the request rather than sending emails with links to the application for approvals

## Description

In this challenge, you will set up a multi-level approval process using Power Automate Flow.
All information extracted from previous challenge should be displayed in the approval notification.

Information:
- Customer Information (Customer name, Address, Email and/or Phone)
- General Order Information (Order Number, Order Date, Order Total)
- Order Detail Information (Product Code, Product Description, Quantity, and Unit Price)
	
Based on the order total you will have different approval steps.
- Less than 25,000 will only require manager approval
- Between 25,000 & 100,000 Manager and Senior manager approval
- More then 100,000 Senior manager & District manager approval
- Both when approver rejects or approves, an email should be sent to the user.
- User should also be able to see if approval is pending and which manager has been requested for the approval.
- Also have the pdf from challenge 3 attached to approval.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Send approval and receive a reply
- Send approval to appropriate user based on the selected order and order total

## Learning Resources

* [Get started with Power Automate Approvals](https://docs.microsoft.com/en-us/power-automate/get-started-approvals)
* [Power Automate Modern Approvals](https://docs.microsoft.com/en-us/power-automate/modern-approvals)
* [Power Automate Approval Attachments](https://docs.microsoft.com/en-us/power-automate/approval-attachments)
* [Get started with Power Automate](https://docs.microsoft.com/power-automate/getting-started)
* [Send an email after approval on record creation in Microsoft Dataverse](https://powerautomate.microsoft.com/en-us/templates/details/8413eeec934b4bbe9a3fd62dc81a00e1/send-an-email-after-approval-on-record-creation-in-microsoft-dataverse/)
* [How to customize date and time values in a Flow](https://support.microsoft.com/en-us/help/4534778/how-to-customize-format-date-and-time-values-in-a-flow)
