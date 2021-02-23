# Challenge \#7 - Admin Your B2C Tenant with MS Graph

[< Previous Challenge](./06-conditional-access.md) - **[Home](./README.md)** - [Next Challenge>](./08-prepare-ief.md)
## Introduction

This challenge is about using an SDK to access the B2C tenant and query it.

There's a sample console app in Resources/MSGraphApp that your team can use. They will need to create a management app in the B2C tenant (link is in the Student challenge) along with getting the App Id of the B2C Extensions App (which should be in place when you provision the B2C tenant).

Your team can modify the .NET Core code to search for specific attributes and even attempt to modify data.

## Hackflow

1. Your team should create a management app in the B2C tenant first. Once they do that, they'll need to collect the management app's client id and secret.
2. Your team should collect the B2C Extensions Application ID - this is found in each B2C tenant
3. Your team should not need the users.json file that's referenced in the appsettings.json file. They can ignore this setting.
4. Once the appsettings.json file has been updated, your team should be able to run the console app and attempt to query attirbutes.
5. Remember that custom attributes in b2c have this format:

```
extension_<ext_app_id_no_dashes>_AttributeName
```

## Tips

Review the README file for the console app - it has a lot of good information about how the application uses MSGraph.

The student needs to change the name of the attributes referenced in the [UserService.cs](../Student/Resources/MSGraphApp/src/Services/UserService.cs) file. Look for the "TODO" call out for the place to make the change.