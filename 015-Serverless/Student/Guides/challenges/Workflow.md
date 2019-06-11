# Challenge 7 - Data Export Workflow

## Prerequisities

1. [Challenge 6 - Monitoring](./Monitoring.md) should be done successfuly.

## Introduction
In this challenge, you create a new Logic App for your data export workflow. This Logic App will execute periodically and call your ExportLicensePlates function, then conditionally send an email if there were no records to export.

1. Create a logic app
    * Name : Similar to TollboothLogic
    * Make sure Log Analytics is Off
    * Trigger should be Recurrence, 15 minutes
2. Add an action to call your &quot;App&quot; function app function name ExportLicensePlates
3. Add a condition control
    * Value : Status Code parameter
    * Operator : is equal to
    * Second value : 200
4. Ignore the True condition
5. In the False condition, send an O365 email
    * To : your email
    * Subject : enter something meaningful
    * Message Body : enter something here and include the status code value
6. Save and Run

## Success Criteria
1. The logic app has executed successfully and you have received an email from your Logic App

## Tips

|                                      |                                                                                                                 |
| ------------------------------------ | :-------------------------------------------------------------------------------------------------------------: |
| **Description**                      |                                                    **Links**                                                    |
| What are Logic Apps?                 |                  <https://docs.microsoft.com/azure/logic-apps/logic-apps-what-are-logic-apps>                   |
| Call Azure Functions from logic apps | <https://docs.microsoft.com/azure/logic-apps/logic-apps-azure-functions%23call-azure-functions-from-logic-apps> |
|                                      |                                                                                                                 |

