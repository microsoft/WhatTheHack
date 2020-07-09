const Hapi = require("hapi");
const appInsights = require("applicationinsights");

// Create a server with a host and port
const server = Hapi.server({
  host: process.env.HOSTNAME || "localhost",
  port: process.env.PORT || 8000,
  routes: {
    cors: {
      origin: [process.env.CORS || "*"]
    }
  }
});

const options = {
  reporters: {
    console: [
      {
        module: "good-squeeze",
        name: "Squeeze",
        args: [
          {
            log: "*",
            response: "*"
          }
        ]
      },
      {
        module: "good-console"
      },
      "stdout"
    ]
  }
};

// Add the route
server.route({
  method: "GET",
  path: "/api/products",
  handler: require("./productsGet"),
  options: {
    cors: { origin: ["*"] }
  }
});

server.route({
  method: "GET",
  path: "/api/inventory/{sku}",
  handler: require("./inventoryGet")
});

server.route({
  method: "POST",
  path: "/api/inventory/{sku}",
  handler: require("./inventoryPost")
});

// Start the server
async function start() {
  await server.register({
    plugin: require("good"),
    options
  });

  let connectionString;
  let dbName;
  let collectionName;
  let appInsightsKey;
  if (process.env.KEYVAULT_URI) {
    server.log("secrets", "pulling secrets from Azure Key Vault");

    await server.register({
      plugin: require("./hapi-azure-key-vault"),
      options: {
        id: process.env.KEYVAULT_ID,
        secret: process.env.KEYVAULT_SECRET,
        uri: process.env.KEYVAULT_URI
      }
    });

    connectionString = server.keyvault.secrets["DB-CONNECTION-STRING"];
    collectionName = server.keyvault.secrets["COLLECTION-NAME"];
    dbName = server.keyvault.secrets["DB_NAME"];
    appInsightsKey = server.keyvault.secrets["APPINSIGHTS-INSTRUMENTATIONKEY"];
  } else if (process.env.DB_CONNECTION_STRING) {
    server.log("secrets", "pulling secrets from process.env");
    connectionString = `${process.env.DB_CONNECTION_STRING}`;
  } else {
    server.log("secrets", "pulling secrets from default");
    connectionString = "mongodb://localhost:27017/tailwind";
  }

  dbName = process.env.DB_NAME ||
    dbName ||
    "tailwind";
  collectionName = process.env.COLLECTION_NAME ||
    collectionName ||
    "inventory";

  appInsightsKey = process.env.APPINSIGHTS_INSTRUMENTATIONKEY || appInsightsKey;
  if (appInsightsKey) {
    appInsights.setup(appInsightsKey);
    appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = "product-service";
    appInsights.start();
    server.log("Application Insights started with key " + appInsightsKey);
  }

  if (process.env.SEED_DATA) {
    await (require("./seedData")({ mongoDbUrl: connectionString, collectionName, dbName }));
  }

  await server.register({
    plugin: require("hapi-mongodb"),
    options: {
      url: connectionString,
      decorate: true
    }
  });

  try {
    await server.start();
  } catch (err) {
    console.log(err);
    process.exit(1);
  }

  console.log("Server running at:", server.info.uri);
}

start();
