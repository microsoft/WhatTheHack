# Challenge 05 - Validation & Custom Response

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

Validation of input data is an important part of any application. As the saying goes, "garbage in, garbage out".

## Description

In this challenge, you will add validation to the `json` workflow to ensure that the required JSON body values are specified. You will also add a custom response to the caller indicating whether the message was accepted or rejected.

- Add a `required` field to the `json` workflow `Parse JSON` action schema to validate that the required JSON body values are specified
- Add a parallel branch after the `Parse JSON` action to handle valid & invalid input data
  - Valid input data should put a message on the Service Bus as before, but with an additional `Response` action afterwards indicated to the caller that the message was accepted (HTTP `202`).
    - Ensure the `Run After` tab on the `Send message` action is set to `Parse JSON is successful`
  - Invalid input data should return a `Response` action with a `400` status code & a `body` message indicating the error
    - Ensure the `Run After` tab on the `Response` action is set to `Parse JSON has failed`
- Test the workflow with valid & invalid JSON input data

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the `json` workflow is validating the JSON body by passing in both valid & invalid data and checking the return values in `Postman`.

## Learning Resources

- [Manage the run after behavior](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-exception-handling?tabs=standard#manage-the-run-after-behavior)

## Tips

A sample JSON schema validation looks like this:
```json
{
    "properties": {
        "orderName": {
            "type": "string"
        },
        "partNumber": {
            "type": "string"
        }
    },
    "required": [
        "orderName",
        "partNumber"
    ],
    "type": "object"
}
```