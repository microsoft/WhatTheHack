// Helper function to call MS Graph API endpoint 
// using authorization bearer token scheme
function callMSGraph(endpoint, token, callback) {
  const headers = new Headers();
  const bearer = `Bearer ${token}`;

  headers.append("Authorization", bearer);

  const options = {
      method: "GET",
      headers: headers
  };

  console.log('request made to Graph API at: ' + new Date().toString());
  
  fetch(endpoint+"/Patient", options)
    .then(response => response.json())
    .then(response => callback(response, endpoint))
    .catch(error => console.log(error))
}

function callPatientSearch(endpoint, token, searchTxt, callback) {
  const headers = new Headers();
  const bearer = `Bearer ${token}`;

  headers.append("Authorization", bearer);

  const options = {
      method: "GET",
      headers: headers
  };

  console.log('request made to Graph API at: ' + new Date().toString());
  
  fetch(endpoint+"/Patient?given:contains="+searchTxt, options)
    .then(response => response.json())
    .then(response => callback(response, endpoint))
    .catch(error => console.log(error))
}
