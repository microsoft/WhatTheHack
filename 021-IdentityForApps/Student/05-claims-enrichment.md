# Challenge \#5 - Claims Enrichment - The ID Verify-inator!!

[< Previous Challenge](./04-l14n.md) - **[Home](../readme.md)** - [Next Challenge>](./06-conditional-access.md)

## Pre-requisites

- Provisioned a B2C tenant
- Created a SignUp / SignIn (SUSI) User Flow
- Tested the User Flow via the Azure AD B2C Portal
- Incorporated a 3rd party IdP (e.g. GitHub, Facebook, etc.)
- Using a custom HTML template
- Localized resources along with multi-language support
- A working Profile Edit User Flow

## Introduction

Azure Active Directory B2C provides the ability to integrate RESTful APIs into your User Flows using a feature called API Connectors, or from your custom policies. This is a great solution for claims enrichment, input validation, workflow kick-off, and many more scenarios.

![REST Integration](https://docs.microsoft.com/en-us/azure/active-directory-b2c/media/technical-overview/lob-integration.png)
## Description

CMC IT Leadership is really impressed with your work - you might get that sweet promotion you've been in line for over the past several years....BUT (oh no), you are hearing rumblings that QA has found an issue with your SignUp / SignIn policy. It seems that QA has been able to enter bogus CMC Consultant IDs during the SignUp process. As a result, anyone could sign up as a consultant with an invalid CMC Consultant ID, which would distort CMC's numbers.

Luckily, a developer on your team has developed a CMC Consultant ID checker function, and named it the "CMC ID Verify-inator". You can find this application in your [Resources](./Resources/Verify-inator) directory. It validates that the CMC Consultant ID entered adheres to the following rules:

- the ID is 10 alphanumeric characters (no special characters or spaces allowed);
- the first three characters are digits, the next four are letters, and the last three are digits;
- the regex for this validation is `[0-9]{3}[a-z,A-Z]{4}[0-9]{3}`

Also, your developer has packaged this in an ASPNETCORE Web Api project (in your resources) which will validate a passed-in CMC Consultant ID and return `true` if the CMC Consultant ID is valid and `false` otherwise. CMC IT Leadership has heard about the "CMC ID Verify-inator" and would like you to incorporate it into your SignUp / SignIn User Flow. If the user passes in an invalid CMC Consultant ID during sign-up, you should prevent the user's account from being created.

Also, your innovative developer has also developed an enhancement to the "CMC ID Verify-inator" that will generate a Consultant Territory Name. Of course, your developer is trying to make a name for themselves, and has leaked this to IT Leadership. As a result, IT Leadership would like you to incorporate this enhancement as part of the sign-up process and this territory name should be a new custom attribute added to the new consultant's account and one of the returned claims when a consultant signs in.

Your developer has also included a configuration setting for the B2C tenant's extension attribute ID. You may want to investigate this setting.

Lastly, CMC IT Leadership does not want to present the "Territory Name" attribute to the user during sign-up. They have asked you to please remove this field from the sign-up experience.

## Success Criteria

CMC IT Leadership considers success in dealing with this QA issue if you are able to:

- Create the new custom attribute for Territory Name in your B2C tenant (named "TerritoryName");
- Deploy the Azure function (the "CMC ID Verify-inator"), code located in [Resources](./Resources/Verify-inator) ;
- Ensure that, during sign-up, a consultant enters a valid CMC Consultant ID; if they pass in an invalid ID, the consultant is presented with a friendly error message;
- Ensure that, during sign-up, a territory name is generated and added to the consultant's account;
- Ensure that, during sign-up, a consultant is not able to enter a territory name and that they do not see a field for territory name (HINT, you may want to alter your custom template just for signup/signin);
- Ensure that, during sign-in, the consultant's territory name is returned as part of their token;
- Ensure that, during profile editing, the consultant's territory name is editable but the CMC Consultant ID is not editable.

## Learning Resources

**[API Connector Overview](https://docs.microsoft.com/en-us/azure/active-directory-b2c/api-connectors-overview)**

**[Adding an API Connector](https://docs.microsoft.com/en-us/azure/active-directory-b2c/add-api-connector)**

## Tips

**[API Connector Best Practices](https://docs.microsoft.com/en-us/azure/active-directory-b2c/add-api-connector#best-practices-and-how-to-troubleshoot)**
