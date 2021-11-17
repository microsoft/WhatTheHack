# Challenge \#4 - Logos, Colors, and Custom Text

[< Previous Challenge](./03-external-idp.md) - **[Home](../README.md)** - [Next Challenge>](./05-claims-enrichment.md)

## Description

CMC IT Leadership is _extremely_ impressed with your SignUp / SignIn flow and how easily you've incorporated a 3rd party IdP......BUT, they have some additional requirements. (You're starting to detect a pattern here.)

### Harness Application

First off, one of your developers has developed a _harness application_ where you can incorporate your SignUp / SignIn User Flow. Your developer has parameterized it so that you should only have to modify your application's settings in order to incorporate the User Flow.

**NOTE:** This web application is located in the [**HarnessApp** folder](Resources/HarnessApp) within the `Resources.zip` file provided by your coach or in the Files tab of your Teams channel.

### Custom Templates and Themes

CMC IT Leadership has decided that, while Slate Gray is a nice theme and all, it's pretty plain. They have asked you to add some custom branding, such as corporate logo and background images, and also to use a different layout for the SignUp / SignIn flow.

CMC IT Leadership would like you to use the provided _HTML layout templates, styles, and images_. You will not need to modify the template unless you want, but you will have to find a place to host these resources. Also, examine the resources in this folder and understand how the templates, CSS files, and images are related. There's a marker for a storage account name in several files, so you may need to replace that at some point.

**NOTE:** These files are located in the **PageTemplates** folder within the `Resources.zip` file provided by your coach or in the Files tab of your Teams channel.

### Custom Field Labels

In addition to this, they would also like to customize some of the text on the pages, specifically they would like:

- Given Name should be "First Name"
- Surname should be "Last Name"
- Your CMC Consultant ID should be "Consultant ID"

### Edit Profile

CMC IT Leadership would also like the ability for the consultant to modify their profile, so they have asked you to create a new User Flow for Profile Editing, using the new HTML template and images, and allow the user to change attributes like:

- First name
- Last name
- Display name

**NOTE:** CMC Consultant ID should not be modifiable!!

### Custom String Values (especially for invalid username/password!)

Lastly, they would also like to have you modify some of the default string values for your sign-in flow, specifically the text that displays when the user logs in with an incorrect user name and/or password. The messages should be consistently vague and not indicate that the user entered either the wrong user name or password -- something like "You entered an incorrect username/password" or "We can't find your account".

## Success Criteria

CMC IT Leadership will consider this step successfully completed if you have:

- Created a new Profile Edit User Flow;
- Incorporated the custom corporate HTML templates, CSS files, and images in your SignUp / SignIn User Flow and Profile Edit User Flow;
- Modified the display values of the several attributes they have requested;
- Modified some default string values which are displayed when a user incorrectly enters their username and/or password;
- Optionally, you have deployed the web harness application that your developer provided to Azure;
- Tested the new look and feel of your SignUp / SignIn User Flow (and specific string customizations) via the web harness that your developer provided.
## Tips

- You don't have to deploy the web harness app to Azure; you can run it locally. However, it would be impressive to CMC IT Leadership if they see the application running in Azure.

- For the custom templates, there is a placeholder for a storage account name. There are files that have a number of `<your-storage-account-name>` markers. Do a global search-and-replace on that marker with your actual storage account name before you upload the files to your storage account.

- In order to upload many files to storage at once, this is a convenient Azure CLI command one might want to use:

    `az storage blob upload-batch -d [container-name] --account-name [storage-acct-name] -s .`

- To deploy the Harness Application, you can deploy it easily using VS Code's [Azure App Service extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice), or via Visual Studio. If you use the App Service extension for VS Code, you can allow the extension to create an app service for you and then you can browse to the website when the deployment is complete.

- Alternative, to get the site up and running quickly this can also be done in a single Azure CLI command as follows:

    `az webapp up -n [name-of-webapp-to-create] -g [name-of-resource-group] -p [name-of-appsvc-plan] -l [location] --runtime "DOTNETCORE|3.1"`

## Learning Resources

- [Customizing Azure AD B2C UX](https://docs.microsoft.com/en-us/azure/active-directory-b2c/customize-ui-overview#custom-html-and-css)

- [Language Customization](https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-flow-language-customization)

- [Deploy Web App to Azure App Service](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/azure-apps/?view=aspnetcore-5.0&tabs=visual-studio)

- [Deploy Web App to Azure App Service using Visual Studio](https://docs.microsoft.com/en-US/visualstudio/deployment/quickstart-deploy-to-azure?view=vs-2019)

- [Create a User Flow in Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/create-user-flow)


## Advanced Challenges (Optional)

_Too comfortable? Eager to do more? Try these additional challenges!_

- Add a second customized language to your User Flows, choosing the language of your choice.

- Azure AD B2C allows you to use [custom JavaScript](https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-flow-javascript-overview) in your custom templates. For your SignIn portion of your User Flow, enable a "[Show Password](https://docs.microsoft.com/en-us/azure/active-directory-b2c/javascript-samples#show-or-hide-a-password)" checkbox to toggle viewing the entered password.
