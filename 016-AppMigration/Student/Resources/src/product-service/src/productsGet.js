module.exports = async function getInventoryList(req) {
  let items, size;
  const pageSize = +req.query.pageSize || 1000;
  const page = +req.query.page || 0;

  const collection =
    process.env.COLLECTION_NAME ||
    (req.keyvault &&
      req.keyvault.secrets &&
      req.keyvault.secrets["COLLECTION-NAME"]) ||
    "inventory";
  try {
    [items, size] = await Promise.all([
      req.mongo.db
        .collection(collection)
        .find()
        .limit(pageSize)
        .skip(pageSize * page)
        .toArray(),
      req.mongo.db
        .collection(collection)
        .find()
        .count()
    ]);
  } catch (e) {
    console.error("e", e);
  }

  return {
    items,
    size
  };
};
