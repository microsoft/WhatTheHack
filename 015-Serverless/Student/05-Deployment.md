# Challenge 5 - Deployment

## Prerequisities

1. [Challenge 4 - Configuration](./04-Configuration.md) should be done successfuly.

## Introduction
In this challenge, you will deploy the VS project to Azure.

1. Deploy the Tollbooth project to the &quot;App&quot; function app you created earlier

**Make sure the publish is successful before moving to the next step**

2. In the portal, add the event grid subscription to the &quot;Process Image&quot; function
  * Event Schema: Event Grid Schema.
  * Topic Type : Storage Accounts.
  * Resource : The first storage account you created.
  * Event type : Blob Created _only_
  * Endpoint type : Leave as is

## Success Criteria
1. The solution successfully deploys to Azure

## Tips


|                                       |                                                                        |
| ------------------------------------- | :--------------------------------------------------------------------: |
| **Description**                       |                               **Links**                                |
| Deploy Functions to Azure | <https://www.thebestcsharpprogrammerintheworld.com/2018/08/21/deploy-an-azure-function-created-from-visual-studio-2/> |
| Create Event Grid Subscription in Azure Function |<https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger?tabs=csharp%2Cbash#azure-portal> |

[Next challenge (Create Functions in the Portal) >](./06-PortalFunctions.md)
