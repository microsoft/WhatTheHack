const https = require("https");
const axios = require("axios");
const instance = axios.create({
  baseURL: "https://[your search service name].search.windows.net",
  timeout: 1000,
  headers: {
    "Content-Type": "application/json",
    "api-key": "[your api key]"
  }
});

module.exports = async function(context, req) {
  context.log("JavaScript HTTP trigger function processed a request.");

  if (req.query.search) {
    var response = await instance.get(
      // Note: get the latest api-version
      "/indexes/documentdb-index/docs?api-version=2020-06-30&search=" +
        req.query.search
    );

    context.res = {
      // status: 200, /* Defaults to 200 */
      body: response.data
    };
  } else {
    context.res = {
      status: 400,
      body: "Please pass a search on the query strin"
    };
  }
};
