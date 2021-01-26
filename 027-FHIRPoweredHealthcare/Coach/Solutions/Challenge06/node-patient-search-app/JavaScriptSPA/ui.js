// Select DOM elements to work with
const welcomeDiv = document.getElementById("welcomeMessage");
const signInButton = document.getElementById("signIn");
const signOutButton = document.getElementById('signOut');
const cardDiv = document.getElementById("card-div");
const mailButton = document.getElementById("readMail");
const profileButton = document.getElementById("seeProfile");
const profileDiv = document.getElementById("profile-div");


function showWelcomeMessage(account) {

    // Reconfiguring DOM elements
    cardDiv.classList.remove('d-none');
    welcomeDiv.innerHTML = `Welcome ${account.name} to the patient search app`;
    signInButton.classList.add('d-none');
    signOutButton.classList.remove('d-none');
}

function updateUI(data, endpoint) {
  console.log('FHIR Server API responded at: ' + new Date().toString());
  console.log(data);

  if (endpoint === fhirConfig.fhirEndpoint) {
    
    profileDiv.innerHTML = '';

    const nameFamily = document.createElement('p');
    const nameGiven = document.createElement('p');
    const resourceId = document.createElement('p');
    const gender = document.createElement('p');
    const patient = document.createElement('p');
    var patientListHtml = '<ol>';

    data.entry.forEach(function(e) {
      patientListHtml += '<li>' + e.resource.name[0].family + ', ' + e.resource.name[0].given + ' (' + e.resource.id + ')' + ', ' + e.resource.gender; 
    });

    patient.innerHTML = patientListHtml;
    profileDiv.appendChild(patient);

  } 
}