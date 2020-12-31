
export default function callPatientSearch(endpoint, token, searchTxt, callback) {
    const headers = new Headers();
    const bearer = `Bearer ${token}`;

    headers.append("Authorization", bearer);

    const options = {
        method: "GET",
        headers: headers
    };

    console.log('request made to FHIR API at: ' + new Date().toString());
    console.log(endpoint);

    // Call FHIR API
    fetch(endpoint+"/Patient?given:contains="+searchTxt, options)
        .then(response => response.json())
        .then(response => callback(response, endpoint))
        .catch(error => console.log(error))
}