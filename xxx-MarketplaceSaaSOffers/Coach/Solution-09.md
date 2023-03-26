# Challenge 09 - Landing page Single Sign On - Coach's Guide 

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)** - [Next Solution >](./Solution-10.md)

## Notes & Guidance

The challenge updates the file: `src/client/landing.html`

The suggested code is listed below in the section **// -- REMOVE FOR STUDENT -- //**

### DOES THIS NEED NGROK?

```
        // --- REMOVE FOR STUDENT --- //
        var pca = new msal.PublicClientApplication({
            auth: {
              clientId: "8dd18476-3e96-4698-bc89-849e12659f9f"
            },
            cache: {
              cacheLocation: "localStorage"
            }
          });
        // -- REMOVE FOR STUDENT -- //
        
        async function signInClick() {
          // -- REMOVE FOR STUDENT -- //
          await pca.loginRedirect({
            scopes: [],
            redirectUri: "https://localhost:3000/landing.html"
          });
          // -- REMOVE FOR STUDENT -- //
          // -- UNCOMMENT FOR STUDENT -- //
          // alert("Challenge 09 - SSO");
        }

        // --- REMOVE FOR STUDENT --- //
        const result = await pca.handleRedirectPromise();

        if (result != null) {
          accessToken = result.accessToken;

          $('#accessToken-details').text(accessToken);
          $('#user-details').attr('open', true);
        }
        // --- REMOVE FOR STUDENT --- //
```