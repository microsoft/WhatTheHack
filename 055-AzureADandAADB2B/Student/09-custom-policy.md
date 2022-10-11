# Challenge \#9 - Creating Custom Policies

[< Previous Challenge](./08-prepare-ief.md) - **[Home](../README.md)** - [Next Challenge>](./10-appinsights.md)

## Description

Now that you've set up the IEF environment, we can implement a new custom policy.

Your CMC Product Group has requested that users should be able to delete their accounts via self-service. They should be able to initiate this process via a web site, and the process will follow these steps:

1. The user will have to log in, either with a local account or their social identity;
2. The user, on successfully signing in, will be presented with a "Are You Sure?" confirmation page;
3. If the user selects "Continue", their account will be deleted and will be presented with a confirmation page;
4. If the user select "Cancel", their account will not be deleted and they will end their user journey.

The CMC Product Group also states that the deleted user account will first be in a suspended state for 30 days and then will be deleted from the B2C directory permanently after that 30 day period.

## Success Criteria

To successfully pass this challenge, you should be able to demonstrate:

- From the Azure AD B2C portal, you should be able to deploy and test the "Delete My Account" custom policy;
- You should be able to delete a local account and a social identity account from your B2C tenant;
- If you cancel out of the policy, the user account should not be deleted


## Tips

- Take a look at the referenced Custom Policy example.

- Consider creating a few dummy users via the Azure B2C Portal for testing.

## Learning Resources

- [RESTful Technical Profile for Custom Policies](https://docs.microsoft.com/en-us/azure/active-directory-b2c/restful-technical-profile)
- [AD B2C Sample - Delete My Account](https://github.com/azure-ad-b2c/samples/tree/master/policies/delete-my-account)
- [UserJourneys and Preconditions reference](https://docs.microsoft.com/en-us/azure/active-directory-b2c/userjourneys)


## Advanced Challenges (Optional)

- Incorporate a button on the sample web page that allows your user to launch the "Delete My Account" custom policy instead of just running and testing it from the Azure AD B2C portal.