const { MongoClient } = require("mongodb");
const { promisify } = require("util");
const { readFile } = require("fs");
const path = require("path");
const csvParse = require("csv-parse");

const rf = promisify(readFile);
const parse = promisify(csvParse);

module.exports = async function seedData({ mongoDbUrl, collectionName, dbName }) {
  const client = await MongoClient.connect(
    mongoDbUrl,
    { useNewUrlParser: true }
    );
    const db = client.db(dbName);
    const hasDocs = await db.collection(collectionName).find().count();
  if (!hasDocs) {
    console.log("No documents in database. Seeding...")
    const csvData = await rf(path.resolve(__dirname, "../scripts/products.csv"));
    const sourceProducts = await parse(csvData, {
      columns: true,
      cast: true
    });    

    const products = sourceProducts.map(p => ({
      "id" : p.id,
      "name" : p.name,
      "price" : p.price,
      "productType" : p.product_type_name,
      "supplierName" : p.supplier_name,
      "sku" : p.sku,
      "shortDescription" : p.short_description,
      "longDescription" : p.long_description,
      "digital" : p.digital,
      "unitDescription" : p.unit_description,
      "dimensions" : p.dimensions,
      "weightInPounds" : p.weight_in_pounds,
      "reorder_amount" : p.reorder_amount,
      "status" : p.status,
      "location" : p.location,
      "images" : [
        {
          "id" : p.id,
          "caption" : p.name,
          "url" : `https://ttcdn.blob.core.windows.net/products/250/${p.id}.jpg`
        }
      ]
    }));

    await db.collection(collectionName).insertMany(products);
  }
};