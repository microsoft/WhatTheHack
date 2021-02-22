import authService from './authService';

export default function updateUI(data, endpoint) {
  var profileDiv = document.getElementById("profile-div");
  var patientListHtml = '';

  console.log('FHIR API responded at: ' + new Date().toString());
  console.log(data);

  if (endpoint === authService.fhirConfig.fhirEndpoint) {   
    profileDiv.innerHTML = ' ';

    const patient = document.createElement('p');
    patientListHtml = '<ol>';
    
    data.entry.forEach(function(e) {
      patientListHtml += '<li>' + e.resource.name[0].family + ', ' + e.resource.name[0].given + ' (' + e.resource.id + ')' + ', ' + e.resource.gender; 

    });
    patientListHtml += '</ol>';
    patient.innerHTML = patientListHtml;
    profileDiv.appendChild(patient);
    
  } 
}

