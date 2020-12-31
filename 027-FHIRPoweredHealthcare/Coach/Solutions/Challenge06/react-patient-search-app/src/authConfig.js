// 
//authConfig.js **** NOT USED IN THIS REACT APP ***
// Config object to be passed to Msal on creation in authService.js
// For a full list of msal.js configuration parameters, 
// visit https://azuread.github.io/microsoft-authentication-library-for-js/docs/msal/modules/_authenticationparameters_.html

msalConfig = {
    auth: {
    clientId: "[Enter_the_Application_Id_Here]",
    authority: "[Enter_Authority URL from FHIR Server Authentication Settings_Here]",
    redirectUri: "[Enter_Your_Patient_Search_WebApp_Uri_Here]",
    },
    cache: {
    cacheLocation: "sessionStorage", // This configures where your cache will be stored
    storeAuthStateInCookie: true, // Set this to "true" if you are having issues on IE11 or Edge
    }
}; 