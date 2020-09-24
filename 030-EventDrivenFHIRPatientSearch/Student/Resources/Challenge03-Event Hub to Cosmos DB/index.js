const cosmos = require("@azure/cosmos");
const CosmosClient = cosmos.CosmosClient;

var globalContainer = undefined;

function getCosmosClient() {
  const client = new CosmosClient({
    endpoint: "https://bfppaaschallcosmos2.documents.azure.com:443",
    auth: {
      masterKey:
        "YEKMFcRStqCE2OOxp7Argj9FV6EaoPFgW3exHKC1KWFlACu9IMwgx1yAVi4s5j0uZPjEt6G0zh7pNShsndtfXA=="
    }
  });

  return client;
}

async function getContainer() {
  if (globalContainer === undefined) {
    let client = getCosmosClient();

    var { database } = await client.databases.createIfNotExists({
      id: "demographics"
    });
    var { container } = await database.containers.createIfNotExists({
      id: "patient"
    });
    globalContainer = container;
  }

  return globalContainer;
}

module.exports = async function(context, eventHubMessages) {
  context.log(
    `JavaScript eventhub trigger function called for message array ${eventHubMessages}`
  );

  let container = await getContainer();
  eventHubMessages.forEach(async (patient, index) => {
    for (var i = 0; i < 3; i++) {
      try {
        await container.items.create(patient.resource);
        break;
      } catch (err) {
        context.log("Error - throttling");
        await new Promise(resolve => setTimeout(resolve, 3000));
      }
    }
  });

  container.close;

  context.log("persited: " + eventHubMessages.length + " patients");
};
