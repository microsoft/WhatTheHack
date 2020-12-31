//authConfig.js
// Config object to be passed to Msal on creation in authService.js
// For a full list of msal.js configuration parameters, 
// visit https://azuread.github.io/microsoft-authentication-library-for-js/docs/msal/modules/_authenticationparameters_.html

msalConfig = {
    auth: {
    clientId: "45538afa-75f7-4d3f-8456-d67f363395ab", //"Enter_the_Application_Id_Here",
    authority: "https://login.microsoftonline.com/wthcontosohealthcare.onmicrosoft.com", //"Enter_the_Cloud_Instance_Id_HereEnter_the_Tenant_Info_Here",
    redirectUri: "http://localhost:3000/", //"Enter_the_Redirect_Uri_Here",
    },
    cache: {
    cacheLocation: "sessionStorage", // This configures where your cache will be stored
    storeAuthStateInCookie: true, // Set this to "true" if you are having issues on IE11 or Edge
    }
}; 