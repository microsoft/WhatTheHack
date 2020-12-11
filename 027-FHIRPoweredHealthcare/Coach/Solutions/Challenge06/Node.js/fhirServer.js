// Helper function to call MS FHIR API endpoint 
// using authorization bearer token scheme
function callFHIRServer(endpoint, token, callback) {
  const headers = new Headers();
  const bearer = `Bearer ${token}`;

  headers.append("Authorization", bearer);

  const options = {
      method: "GET",
      headers: headers
  };

  console.log('request made to FHIR Server API at: ' + new Date().toString());
  
  fetch(endpoint, options)
    .then(response => response.json())
    .then(response => callback(response, endpoint))
    .catch(error => console.log(error))
}
