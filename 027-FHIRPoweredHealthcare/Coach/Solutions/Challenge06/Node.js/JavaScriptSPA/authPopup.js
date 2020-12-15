// Create the main myMSALObj instance
// configuration parameters are located at authConfig.js
const myMSALObj = new Msal.UserAgentApplication(msalConfig);

function signIn() {
  myMSALObj.loginPopup(loginRequest)
    .then(loginResponse => {
      console.log("id_token acquired at: " + new Date().toString());
      console.log(loginResponse);
      
      if (myMSALObj.getAccount()) {
        showWelcomeMessage(myMSALObj.getAccount());
      }
    }).catch(error => {
      console.log(error);
    });
}

function signOut() {
  myMSALObj.logout();
}

function getTokenPopup(request) {
  return myMSALObj.acquireTokenSilent(request)
    .catch(error => {
      console.log(error);
      console.log("silent token acquisition fails. acquiring token using popup");
          
      // fallback to interaction when silent call fails
        return myMSALObj.acquireTokenPopup(request)
          .then(tokenResponse => {
            return tokenResponse;
          }).catch(error => {
            console.log(error);
          });
    });
}

function seeAllPatients() {
  if (myMSALObj.getAccount()) {
    getTokenPopup(loginRequest)
      .then(response => {
        callFHIRServer(fhirConfig.fhirEndpoint, response.accessToken, updateUI);
      }).catch(error => {
        console.log(error);
      });
  }
}


function searchPatient(searchTxt) {
  //endpoint = graphConfig.graphMeEndpoint + "/Patient?given:contains=" + searchTxt;
  if (myMSALObj.getAccount()) {
    getTokenPopup(loginRequest)
      .then(response => {
        callPatientSearch(graphConfig.graphMeEndpoint, response.accessToken, searchTxt, updateUI);
      }).catch(error => {
        console.log(error);
      });
  }
}