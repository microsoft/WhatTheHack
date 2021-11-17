# Challenge \#5 - Claims Enrichment - The ID Verify-inator!!

[< Previous Challenge](./04-l14n.md) - **[Home](../README.md)** - [Next Challenge>](./06-conditional-access.md)
## Introduction

Azure Active Directory B2C provides the ability to integrate RESTful APIs into your User Flows using a feature called API Connectors, or from your custom policies. This is a great solution for claims enrichment, input validation, workflow kick-off, and many more scenarios.

![REST Integration](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/technical-overview/lob-integration.png)
## Description

CMC IT Leadership is really impressed with your work - you might get that sweet promotion you've been in line for over the past several years....BUT (oh no), you are hearing rumblings that QA has found an issue with your SignUp / SignIn policy. It seems that QA has been able to enter bogus CMC Consultant IDs during the SignUp process. As a result, anyone could sign up as a consultant with an invalid CMC Consultant ID, which would distort CMC's numbers.

Luckily, a developer on your team has developed a CMC Consultant ID checker Web API, and named it the "CMC ID Verify-inator". It validates that the CMC Consultant ID entered adheres to the following rules:

- the ID is 10 alphanumeric characters (no special characters or spaces allowed);
- the first three characters are digits, the next four are letters, and the last three are digits;
- the regex for this validation is `[0-9]{3}[a-z,A-Z]{4}[0-9]{3}`

Also, your developer has packaged this in an ASPNETCORE Web Api project (in your resources) which will validate a passed-in CMC Consultant ID and return `true` if the CMC Consultant ID is valid and `false` otherwise. CMC IT Leadership has heard about the "CMC ID Verify-inator" and would like you to incorporate it into your SignUp / SignIn User Flow. If the user passes in an invalid CMC Consultant ID during sign-up, you should prevent the user's account from being created.

Also, your innovative developer has also developed an enhancement to the "CMC ID Verify-inator" that will generate a Consultant Territory Name. Of course, your developer is trying to make a name for themselves, and has leaked this to IT Leadership. As a result, IT Leadership would like you to incorporate this enhancement as part of the sign-up process and this territory name should be a new custom attribute added to the new consultant's account and one of the returned claims when a consultant signs in.

Your developer has also included a configuration setting for the B2C tenant's extension attribute ID. You may want to investigate this setting.

You will call the Verify-inator at its `/Territory` endpoint. So if you deployed the Verify-inator to `https://foo.azurewebsites.net`, then when you create the API Connector, you should set its endpoint to be `https://foo.azurewebsites.net/Territory`.

Lastly, CMC IT Leadership does not want to present the "Territory Name" attribute to the user during sign-up. They have asked you to please remove this field from the sign-up experience.

**NOTE:** This ASPNETCORE web api application is located in the **Verify-inator** folder within the `Resources.zip` file provided by your coach or in the Files tab of your Teams channel.

## Background

Azure AD B2C has a new feature named API Connectors, which allow your B2C User Flows to communicate with REST APIs during the user sign up process. Our application will take advantage of API Connectors.

When calling the Verify-inator API Connector, all attributes collected from the user signing up will be passed to the Verify-inator. It will be in a flat JSON payload, looking like this:

```Javascript
{
    "givenName": "Dave",
    "surname": "Lassname",
    "extension_123xzy_ConsultantID": "123ABCD456",
    "state": "PA",
    "city": "Pittsburgh"
}
```

Notice that when the `ConsultantID` is passed to the API Connector, it is formatted as `extension_<ext_app_id>_ConsultantID`. The `<ext_app_id>` piece in the middle is the App ID of the B2C Extensions app in your B2C tenant. That app registration was created when your B2C tenant was created - you'll just need to copy the Client (App) ID and update your project's appsettings.json file.

The Verify-inator will return a JSON object back to your B2C User Flow. Generally, it will be in this format:

```Javascript
{
    { "version": "1.0.0" },
    { "action": "Continue" },
    { "userMessage", "Success!" },
    { "extension_123xyz_ConsultantID": "123ABCD456" },
    { "extension_123xyz_TerritoryName": "Shiny-Bubble" }
}
```

Your UserFlow will update all claims that are returned (such as TerritoryName) and persist them.

## Success Criteria

CMC IT Leadership considers success in dealing with this QA issue if you are able to:

- Create the new custom attribute for Territory Name in your B2C tenant (named "TerritoryName");
- Deploy the "CMC ID Verify-inator" code in the **Verify-inator** folder within the `Resources.zip` file provided by your coach or in the Files tab of your Teams channel;
- Ensure that, during sign-up, a consultant enters a valid CMC Consultant ID; if they pass in an invalid ID, the consultant is presented with a friendly error message;
- Ensure that, during sign-up, a territory name is generated and added to the consultant's account;
- Ensure that, during sign-up, a consultant is not able to enter a territory name and that they do not see a field for territory name (HINT, you may want to alter your custom template just for signup/signin);
- Ensure that, during sign-in, the consultant's territory name is returned as part of their token;
- Ensure that, during profile editing, the consultant's territory name is editable but the CMC Consultant ID is not editable.

## Learning Resources

- [API Connector Overview](https://docs.microsoft.com/en-us/azure/active-directory-b2c/api-connectors-overview)

- [Adding an API Connector](https://docs.microsoft.com/en-us/azure/active-directory-b2c/add-api-connector)

- [API Connector Best Practices](https://docs.microsoft.com/en-us/azure/active-directory-b2c/add-api-connector#best-practices-and-how-to-troubleshoot)