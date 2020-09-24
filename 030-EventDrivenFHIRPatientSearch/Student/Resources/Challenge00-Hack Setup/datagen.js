const _ = require("lodash");
const AuthenticationContext = require("adal-node").AuthenticationContext;
const Faker = require("faker");
const axios = require("axios");
const sleep = require("sleep");

// read in config and replace any default values with env specific ones
const config = require('./config.json');
const defaultConfig = config.default;
const environment = process.env.NODE_ENV || 'default';
const environmentConfig = config[environment];
const finalConfig = _.merge(defaultConfig, environmentConfig);

// best practice naming for globals
global.gConfig = finalConfig;

// add in the authority URL to the config
global.gConfig.authorityUrl = global.gConfig.authorityHostUrl + "/" + global.gConfig.tenant;

async function loadSamplePatients(token) {
  var instance = axios.create({
    baseURL: global.gConfig.fhirApiUrl,
    headers: { Authorization: "Bearer " + token }
  });

  for (var i = 0; i < 1000; i++) {
    var requests = [];

    for (var r = 0; r < 25; r++) {
      requests.push(instance.post("/Patient", getPatient()));
    }

    try {
      var responses = await Promise.all(requests);

      responses.forEach((response, ndx, arr) => {
        if (response.status === 201) {
          console.log(
            "Created patient " +
              (i * arr.length + ndx) +
              ": " +
              response.data.id
          );
        } else {
          console.log(response);
          throw Error("FAILED - Unexpected error!!!!");
        }
      });
    } catch (e) {
      i--;
      if (e.response && e.response.status === 429) {
        console.log("Throttled - waiting 2 seconds");
        sleep.sleep(2);
      } else {
        console.log("FAILED - Unexpected error!!!!");
        console.log(`Response: ${e.response.status} ${e.response.statusText}`);
        console.log("Waiting 2 seconds");
        sleep.sleep(2);
      }
    }
  }
}

function getPatient() {
  var date = Faker.date.past(100);
  var addressDate = Faker.date.past(7);
  var fhirPatient = {
    resourceType: "Patient",
    active: true,
    name: [
      {
        use: "official",
        family: [Faker.name.lastName()],
        given: [Faker.name.firstName()]
      }
    ],
    gender: Math.random() < 0.5 ? "male" : "female",
    birthDate: date.getFullYear() + "-" + date.getMonth() + "-" + date.getDay(),
    address: [
      {
        use: "home",
        type: "both",
        line: [Faker.address.streetAddress()],
        city: Faker.address.city(),
        state: Faker.address.state(),
        postalCode: Faker.address.zipCode(),
        period: {
          start:
            addressDate.getFullYear() +
            "-" +
            addressDate.getMonth() +
            "-" +
            addressDate.getDay()
        }
      }
    ]
  };

  return fhirPatient;
}

function go() {
  var context = new AuthenticationContext(global.gConfig.authorityUrl);
  context.acquireTokenWithClientCredentials(
    global.gConfig.resource,
    global.gConfig.applicationId,
    global.gConfig.clientSecret,
    (err, response) => {
      if (err) {
        console.log("Failed to get token!");
      } else {
        loadSamplePatients(response.accessToken);
      }
    }
  );
}

go();
