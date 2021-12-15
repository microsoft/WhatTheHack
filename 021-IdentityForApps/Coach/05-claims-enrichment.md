# Challenge \#5 - Claims Enrichment - The ID Verify-inator!!

[< Previous Challenge](./04-l14n.md) - **[Home](./README.md)** - [Next Challenge>](./06-conditional-access.md)
## Introduction

In this challenge, the team will host an simple Azure App Service and connect their SUSI User Flow to it for claims enrichment and validation.

## Hackflow

This challenge should follow a simple flow

1. The team will take the web app that's in Resources/Verify-inator and deploy it as an Azure App Service Web App. They can simply do this from VS Code using the Azure App Service extension. The Web App is very simple and does not have any add'l dependencies.
2. Once the Web App is deployed, you should have your team test it via Postman in order to ensure that it is reachable and is returning valid responses. An example POST request would look something like this (cUrl format):

```
curl --location --request POST 'https://localhost:5001/Territory' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "stuff",
    "something-else": "asdf",
    "extension_c25a588869c34cb48d8d87dbbce4816b_ConsultantID": "123abcd450"
}'

### RESPONSE ###

{
    "version": "1.0.0",
    "action": "Continue",
    "userMessage": "The invitation code you provided is valid.",
    "extension_c25a588869c34cb48d8d87dbbce4816b_ConsultantID": "123abcd450",
    "extension_c25a588869c34cb48d8d87dbbce4816b_TerritoryName": "Unquenchable-Ensemble"
}
```

3. Once the REST API has been deployed, go to the B2C tenant and create an API Connector. Since the REST API does not check for a username or password, just provide a dummy username/password for the API Connector setup.
4. After setting up the API Connector, go to your SUSI User Flow and enable an API Connector by selecting the API Conector you created above for the **Before creating the user** stage.
5. Save your User Flow and test it out using the web harness. Create new user (you may want to disable email verification in the User Flow under **Page Layouts -> Local Account Sign Up Page** and **Page Layouts -> Social Account Sign Up Page**).
6. If you provide a valid code (3 digits, 4 alpha, 3 digits), you should get back a territory name as a claim.

## Tips

1. Ensure that the User Flow collects both the Consultant ID **_and_** the Territory Name (even though Territory Name is populated by the API Connector). You can modify the custom HTML template to select the label and text box for Territory Name and set it to `display:none` for a style.
2. To hide the custom attribute "Territory Name" from the SignUp page, you will need to add some CSS to your custom template. You may want your students to create a second custom template, one for signup/signin and one for profile edit. The template for signup/signin will hide the TerritoryName, but edit profile will still display it.
3. You can hide the TerritoryName attribute by using this snippet of CSS:

```CSS
<style>
    /* You may want to uncomment this to prevent displaying the Territory Name attribute! */
    /* .extension_TerritoryName_li {
      display: none;
    } */
</style>
```
