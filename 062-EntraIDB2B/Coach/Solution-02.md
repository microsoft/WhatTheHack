# Challenge 02 - Sign Me In! - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

Open the [authr](https://authr.dev/?requesttype=OpenIdConnect&scope=openid+profile&responsetype=id_token&responsemode=form_post&additionalparameters=prompt%3dlogin&importtype=AzureAD&tenant=microsoft.onmicrosoft.com&clientid=your-client-id) link.

Make sure to change the tenant=microsoft.onmicrosoft.com in the query parameter to the newly created tenant. It should be tenant=yourtenantname.onmicrosoft.com

Verify that the Authorization Endpoint and the Token Endpoint reflects the change.

Copy the Client ID from the Azure Portal by navigation Entra ID - App Registration - Overview - Application (client) ID.

No need to put the Client Secret in the form.

Verify the Additional Parameters textbox. It should be populated as prompt=login.

Everything else should remain as default.

Login using the newly created user in the new tenant.

Verify the claims in the JWT. Check the "aud", "iss", "idp" claims specifically.



