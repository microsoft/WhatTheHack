 
// Config object to be passed to Msal on creation.
// For a full list of msal.js configuration parameters, 
// visit https://azuread.github.io/microsoft-authentication-library-for-js/docs/msal/modules/_authenticationparameters_.html
const msalConfig = {
  auth: {
    clientId: "<Enter_the_Application_Id_Here>",
    authority: "<Enter_Authority value from FHIR Server Authentication setting>",
    redirectUri: "<Enter_the_Redirect_Uri_Here>",
  },
  cache: {
    cacheLocation: "sessionStorage", // This configures where your cache will be stored
    storeAuthStateInCookie: false, // Set this to "true" if you are having issues on IE11 or Edge
  }
};  
  
// Add here the scopes to request when obtaining an access token for FHIR Server API
// for more, visit https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-core/docs/scopes.md
const loginRequest = {
  scopes: ["<Enter_your FHIR Server URL>/.default"]
};

// Add here scopes for access token to be used at FHIR Sercver API endpoints.
const tokenRequest = {
  scopes: ["<Enter_your FHIR Server URL>/.default"]
};