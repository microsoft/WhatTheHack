const AuthenticationContext = require("adal-node").AuthenticationContext;
const Fhir = require("fhir.js");

async function processPatients(context, patients) {
  patients.forEach((patient, index) => {
    context.log(
      index +
        ":  " +
        patient.resource.id +
        ":  " +
        patient.resource.name[0].family +
        ", " +
        patient.resource.name[0].given[0]
    );
  });
}

function getAuthenticationToken(context) {
  return new Promise((resolve, reject) => {
    const authContext = new AuthenticationContext(
      "https://login.windows.net/[your tenant].onmicrosoft.com"
    );
    authContext.acquireTokenWithClientCredentials(
      "https://azurehealthcareapis.com",
      "[your adalConfiguration.clientID]",
      "[adalConfiguration.clientSecret]",
      (err, response) => {
        if (err) {
          reject(err);
        } else {
          resolve(response.accessToken);
        }
      }
    );
  });
}

async function foreachPatient(baseUrl, token, logContext, callback) {
  return new Promise(async (resolve, reject) => {
    /// setup client
    const client = Fhir({
      baseUrl: baseUrl,
      auth: {
        bearer: token
      }
    });

    try {
      // grab the inital search response
      var response = await client.search({
        type: "Patient",
        query: {
          _count: 100,
          _page: 1
        }
      });

      // callback
      await callback(logContext, response.data.entry);

      // loop through remaining pages.
      var nextPage = response.data.link.find(link => link.relation === "next");
      while (nextPage !== undefined) {
        response = await client.nextPage({ bundle: response.data });
        await callback(logContext, response.data.entry);
        nextPage = response.data.link.find(link => link.relation === "next");
      }
    } catch (err) {
      reject(err);
    }
    resolve();
  });
}

module.exports = async function(context, req) {
  /// Do the thing!
  const token = await getAuthenticationToken(context);
  await foreachPatient(
    "[your fhir server base url]",
    token,
    context,
    processPatients
  );
};
