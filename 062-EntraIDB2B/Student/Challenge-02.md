# Challenge 02 - Sign Me In!

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

To see the end user sign-in experience of the app you just registered, use this [direct](https://authr.dev/?requesttype=OpenIdConnect&scope=openid+profile&responsetype=id_token&responsemode=form_post&additionalparameters=prompt%3dlogin&importtype=AzureAD&tenant=microsoft.onmicrosoft.com&clientid=your-client-id) link and replace the Client ID on the form with the correct Application (client) ID value from the app registration and update the endpoints with the your tenant.

## Success Criteria

1. After the successful sign-in, the application shows the ID token that was issued by the directory, containing relevant claims about the signed-in user.

