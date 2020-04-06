const { MongoClient } = require("mongodb");
const { Client: PgClient } = require("pg");
const toCamelCase = require("to-camel-case");
const { promisify } = require("util");
const { readFile } = require("fs");
const path = require("path");
const csvParse = require("csv-parse");
const dataMaker = require("./dataMaker");

const rf = promisify(readFile);
const parse = promisify(csvParse);

const url =
  process.env.DB_CONNECTION_STRING || "mongodb://localhost:27017/tailwind";
const dbName = process.env.DB_NAME || "tailwind";
const collectionName = process.env.COLLECTION_NAME || "inventory";
const numberOfItems = process.env.ITEMS_AMOUNT || 10000;
const imageSize = process.env.IMAGE_SIZE || 250;
const sectionLength = process.env.SECTION_LENGTH || 10000;

const processImage = image => ({
  id: image.id,
  caption: image.name,
  url: `https://ttcdn.blob.core.windows.net/products/${imageSize}/${
    image.id
  }.jpg`
});

const randomNum = num => Math.floor(num * Math.random());
const getRandomImagesArray = (images = [], max = 3) =>
  Array.from({ length: 1 + randomNum(max) })
    .map(() => images[randomNum(images.length)])
    .reduce((acc, item) => {
      if (!acc.includes(item)) {
        acc.push(item);
      }
      return acc;
    }, [])
    .map(processImage);

async function insert() {
  const csvData = await rf(path.resolve(__dirname, "./images.csv"));
  const images = await parse(csvData, {
    columns: true,
    cast: true
  });

  let items = [];
  if (process.env.PG_CONNECTION_STRING) {
    console.log("PG connection string detected, reading from Postgres");
    const pg = new PgClient({
      connectionString: process.env.PG_CONNECTION_STRING,
      ssl: true
    });

    pg.connect();

    const existing = await pg.query(`
      SELECT 
        products.id, 
        products.name, 
        products.sku, 
        products.price, 
        products.short_description, 
        products.long_description,
        products.digital,
        products.unit_description,
        products.dimensions,
        products.weight_in_pounds,
        products.reorder_amount,
        products.status,
        products.location,
        suppliers.name as supplier_name,
        product_types.name as product_type
      FROM products, suppliers, product_types
      WHERE 
        suppliers.id = products.supplier_id
      AND
        product_types.id = products.product_type_id;
    `);

    items = existing.rows;

    items = items.map(item =>
      Object.keys(item).reduce(
        (acc, key) => {
          acc[toCamelCase(key)] = item[key];
          return acc;
        },
        { images: getRandomImagesArray(images) }
      )
    );

    await pg.end();
  } else {
    console.log("PG connection string not detected, skipping Postgres");
  }

  console.log(
    `received ${items.length} from Postgres, filling in ${numberOfItems -
      items.length} items with randomly generated data`
  );

  items = items.concat(
    dataMaker(items.length + 1, numberOfItems).map(obj => {
      obj.images = getRandomImagesArray(images);
      return obj;
    })
  );

  console.log("starting MongoDB");
  console.log(
    `local: ${url ===
      "mongodb://localhost:27017"} | db: ${dbName} | collection: ${collectionName} | number of items: ${numberOfItems} | section lengths: ${sectionLength}`
  );
  const client = await MongoClient.connect(
    url,
    { useNewUrlParser: true }
  );
  const db = client.db(dbName);

  console.log("starting mongoDB inserts");

  const responses = [];
  for (let i = 0; i < Math.floor(items.length / sectionLength); i++) {
    const cur = items.slice(i * sectionLength, (i + 1) * sectionLength);
    const res = await db.collection(collectionName).insertMany(cur);
    console.log(`iteration ${i} | inserted ${res.insertedCount}`);
    responses.push(res);
  }

  const count = responses
    .map(({ insertedCount }) => insertedCount)
    .reduce((acc, item) => item + acc);

  console.log(
    `finished insert, inserted ${count} items over ${
      responses.length
    } iterations`
  );

  await client.close();

  console.log(`closed connection, finished`);
}

try {
  insert();
} catch (e) {
  console.error(e);
}
