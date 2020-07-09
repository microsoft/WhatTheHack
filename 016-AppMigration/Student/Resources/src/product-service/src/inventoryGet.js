module.exports = function inventoryGet(req) {
  return { sku: req.params.sku, count: Math.floor(Math.random() * 1000) };
};
