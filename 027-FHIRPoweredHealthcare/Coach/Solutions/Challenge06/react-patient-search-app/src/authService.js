import { UserAgentApplication } from 'msal';
import authConfig from './authConfig.json';
import showWelcomeMessage from './showWelcomeMessage';

class AuthService {
constructor(configuration) {
    this.signInOptions = {
    scopes: configuration.msal.scopes
    };

    //authConfig.json
    // MSAL Config object to be passed to Msal on creation.
    // For a full list of msal.js configuration parameters, 
    // visit https://azuread.github.io/microsoft-authentication-library-for-js/docs/msal/modules/_authenticationparameters_.html   
    this.msalConfig = {
    auth: {
        authority: configuration.msal.authority,
        clientId: configuration.msal.clientId,
        redirectUri: configuration.msal.redirectUri   //window.location.href
    },
    cache: {
      cacheLocation: configuration.cache.cacheLocation, //cacheLocation: 'sessionStorage',
      storeAuthStateInCookie: configuration.cache.storeAuthStateInCookie  //storeAuthStateInCookie: true
    }   
    };

    // Create the main msalclient instance
    // configuration parameters are located at local msalConfig object or authConfig.js
    this.msalClient = new UserAgentApplication(this.msalConfig);
    console.log('AuthService: initialized: ', this.msalConfig);

    this.loginRequest = {
      scopes: configuration.loginRequest.scopes
    };
  
    // Add here scopes for access token to be used at MS Graph API endpoints.
    this.tokenRequest = {
        scopes: configuration.loginRequest.scopes
    };

    //fhirConfig.js
    // Add here the endpoints for FHIR API services you would like to use.
    this.fhirConfig = {
        fhirEndpoint: configuration.fhirConfig.fhirEndpoint
    };
}
  
get serviceName() { return 'Microsoft'; }

// msal login
async signIn() {
    
    //const response = await this.msalClient.loginPopup(this.loginRequest)
    await this.msalClient.loginPopup(this.signInOptions)
    .then(loginResponse => {
      console.log("id_token acquired at: " + new Date().toString());
      console.log(loginResponse);
      
      if (this.msalClient.getAccount()) {
        showWelcomeMessage(this.msalClient.getAccount());
      }
    }).catch(error => {
      console.log(error);
    });
    
    //return new Identity(response);
    return;
}

// msal logout
signOut() {
    this.msalClient.logout();
}

// msal acquireTokenSilent
getTokenPopup(request) {
    return this.msalClient.acquireTokenSilent(request)
      .catch(error => {
        console.log(error);
        console.log("silent token acquisition fails. acquiring token using popup");
            
        // fallback to interaction when silent call fails
          return this.msalClient.acquireTokenPopup(request)
            .then(tokenResponse => {
              return tokenResponse;
            }).catch(error => {
              console.log(error);
            });
      });
}


}

const authService = new AuthService(authConfig);

export default authService;