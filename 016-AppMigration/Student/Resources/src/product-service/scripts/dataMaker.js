const faker = require("faker");

const random = num => Math.floor(Math.random() * num);
const dimension = () => `${random(100)}${["in", "ft"][random(2)]}`;
const randomLetter = () => "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(random(26));
const skuGenerator = () =>
  Array.from({ length: 20 })
    .map(randomLetter)
    .join("");

const methods = {
  name: () => faker.commerce.productName(),
  price: () => faker.commerce.price(),
  productType: () => faker.commerce.department(),
  supplierName: () => faker.company.companyName(),
  sku: () => skuGenerator(),
  shortDescription: () => faker.lorem.words(),
  longDescription: () => faker.lorem.sentences(),
  digital: () => Math.random() > 0.5,
  unitDescription: () => faker.lorem.sentence(),
  dimensions: () => `${dimension()} x ${dimension()} x ${dimension()}`,
  weightInPounds: () => random(100),
  reorder_amount: () => random(100),
  status: () => "in-stock",
  location: () =>
    `Row ${randomLetter()}, Level ${random(100)}, Shelf ${random(
      100
    )}, Position ${random(100)}`
};

module.exports = function dataMaker(startAt, length) {
  const ans = [];

  for (let i = startAt; i <= length; i++) {
    const obj = { id: i };
    Object.keys(methods).forEach(method => {
      obj[method] = methods[method]();
    });
    ans.push(obj);
  }
  return ans;
};
