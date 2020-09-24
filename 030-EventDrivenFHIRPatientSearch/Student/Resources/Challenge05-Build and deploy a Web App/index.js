const https = require("https");
const axios = require("axios");
const instance = axios.create({
  baseURL: "https://bfpchallsearch.search.windows.net",
  timeout: 1000,
  headers: {
    "Content-Type": "application/json",
    "api-key": "66E8ACCB57185E7AED0FFC355D4075E7"
  }
});

module.exports = async function(context, req) {
  context.log("JavaScript HTTP trigger function processed a request.");

  if (req.query.search) {
    var response = await instance.get(
      "/indexes/documentdb-index/docs?api-version=2017-11-11&search=" +
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
