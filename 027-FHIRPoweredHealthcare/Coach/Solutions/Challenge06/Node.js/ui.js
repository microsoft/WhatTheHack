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
    welcomeDiv.innerHTML = `Welcome ${account.name}`;
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

    // Iterate through all returned patient resources
    data.entry.forEach(function(e) {
      nameFamily.innerHTML = e.resource.name[0].family;
      nameGiven.innerHTML = e.resource.name[0].given;
      resourceId.innerHTML = ' (' + e.resource.id + ')';
      gender.innerHTML = e.resource.gender;

      profileDiv.appendChild(nameFamily);
      profileDiv.appendChild(nameGiven);
      profileDiv.appendChild(resourceId);
      profileDiv.appendChild(gender);
    });

    
  } 
}