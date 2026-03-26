import { MongoClient } from "mongodb"

let theaters
describe("Basic Updates", () => {
  /**
   * In this lesson, we'll discuss updating documents with the Node.js driver.
   * There are two different update operations we can perform - updateOne(), and
   * updateMany().
   *
   * These operations both return an UpdateResult, which we'll discuss as well.
   */

  beforeAll(async () => {
    try {
      theaters = await global.mflixClient
        .db(process.env.MFLIX_NS)
        .collection("theaters")
    } catch (e) {
      console.error(
        `Unable to establish a collection handle for "mflix.theaters": ${e}`,
      )
    }
  })

  it("Can update one document in a collection", async () => {
    /**
     * We can update a single document in a collection with updateOne().
     * updateOne() takes a query predicate, to match a document, and a JSON
     * object of one or more update operators, describing how to update that
     * document.
     *
     * If the predicate matches more than one document, updateOne() will update
     * the first document it finds in the collection. This may be unpredictable,
     * so the query predicate we use should only match one document.
     *
     * In the following example, one of the theaters in our database moved
     * location, down the street from its original address.
     *
     * This operation should only update one of the theaters in this collection,
     * to change the address of that theater. It performs the following updates:
     *
     * Use $set to update the new address of this theater
     * Use $inc to update the new geo coordinates of this theater
     */

    // when accessing a subdocument, we must use quotes
    // for example, "location.address.street1" would fail without quotes
    const oldTheaterAddress = await theaters.findOne({ theaterId: 8 })

    // expect the address of this theater to be "14141 Aldrich Ave S"
    expect(oldTheaterAddress.location.address.street1).toEqual(
      "14141 Aldrich Ave S",
    )
    expect(oldTheaterAddress.location.geo.coordinates).toEqual([
      -93.288039,
      44.747404,
    ])

    // update a single theater document in this collection
    const updateOneResult = await theaters.updateOne(
      { theaterId: 8 },
      {
        $set: { "location.address.street1": "14161 Aldrich Ave S" },
        $inc: {
          "location.geo.coordinates.0": -10,
          "location.geo.coordinates.1": -25,
        },
      },
    )

    // expect this operation to match exactly 1 theater document
    expect(updateOneResult.matchedCount).toEqual(1)

    // expect this operation to update exactly 1 theater document
    expect(updateOneResult.modifiedCount).toEqual(1)

    const newTheaterAddress = await theaters.findOne(
      { theaterId: 8 },
      { "location.address.street1": 1 },
    )

    // expect the updated address of this theater to be "14161 Aldrich Ave S"
    expect(newTheaterAddress.location.address.street1).toEqual(
      "14161 Aldrich Ave S",
    )
    expect(newTheaterAddress.location.geo.coordinates).toEqual([
      -103.288039,
      19.747404000000003,
    ])

    // do some cleanup
    const cleanUp = await theaters.updateOne(
      { theaterId: 8 },
      {
        $set: { "location.address.street1": "14141 Aldrich Ave S" },
        $inc: {
          "location.geo.coordinates.0": 10,
          "location.geo.coordinates.1": 25,
        },
      },
    )

    expect(cleanUp.modifiedCount).toEqual(1)
  })

  it("Can update many documents in a collection", async () => {
    /**
     * We can update multiple documents in a collection with updateMany().
     *
     * Like updateOne(), updateMany() takes a query predicate and a JSON object
     * containing one or more update operators.
     *
     * But unlike updateOne(), updateMany() will update any documents matching
     * the query predicate.
     *
     * In the following example, the state of Minnesota has relocated one of its
     * zip codes, 55111, from Minneapolis to the neighboring city of
     * Bloomington.
     *
     * This operation should find all the movie theaters in the zip code 55111,
     * and update the value of the "city" field to Bloomington.
     */

    const oldTheaterDocuments = await (await theaters.find({
      "location.address.zipcode": "55111",
    })).toArray()

    // expect all the theaters in 55111 to reside in Minneapolis
    oldTheaterDocuments.map(theater => {
      expect(theater.location.address.city).toEqual("Minneapolis")
    })

    // same query predicate as the find() statement above
    const updateManyResult = await theaters.updateMany(
      { "location.address.zipcode": "55111" },
      { $set: { "location.address.city": "Bloomington" } },
    )

    // expect this operation to match exactly 6 theater document
    expect(updateManyResult.matchedCount).toEqual(6)

    // expect this operation to update exactly 6 theater document
    expect(updateManyResult.modifiedCount).toEqual(6)

    const newTheaterDocuments = await (await theaters.find({
      "location.address.zipcode": "55111",
    })).toArray()

    // expect all the updated theater documents to reside in Bloomington
    newTheaterDocuments.map(theater => {
      expect(theater.location.address.city).toEqual("Bloomington")
    })

    // clean up
    const cleanUp = await theaters.updateMany(
      { "location.address.zipcode": "55111" },
      { $set: { "location.address.city": "Minneapolis" } },
    )

    expect(cleanUp.modifiedCount).toEqual(6)
  })

  it("Can update a document if it exists, and insert if it does not", async () => {
    /**
     * Sometimes, we want to update a document, but we're not sure if it exists
     * in the collection.
     *
     * We can use an "upsert" to update a document if it exists, and insert it
     * if it does not exist.
     *
     * In the following example, we're not sure if this theater exists in our
     * collection, but we want to make sure there is a document in the
     * collection that contains the correct data.
     *
     * This operation may do one of two things:
     *
     * If the predicate matches a document, update the theater document to
     * contain the correct data
     * If the document doesn't exist, create the desired theater document
     */

    const newTheaterDoc = {
      theaterId: 954,
      location: {
        address: {
          street1: "570 2nd Ave",
          street2: null,
          city: "New York",
          state: "NY",
          zipcode: "10016",
        },
        geo: {
          type: "Point",
          coordinates: [-75, 42],
        },
      },
    }

    const upsertResult = await theaters.updateOne(
      {
        "location.address": newTheaterDoc.location.address,
      },
      {
        $set: newTheaterDoc,
      },
      { upsert: true },
    )

    // expect this operation not to match any theater documents
    expect(upsertResult.matchedCount).toEqual(0)

    // expect this operation not to update any theater documents
    expect(upsertResult.modifiedCount).toEqual(0)

    // this upsertedId contains the _id of the document that we just upserted
    expect(upsertResult.upsertedId).not.toBeNull()
    console.log(upsertResult.upsertedId)

    // remove the document so it can be upserted again
    const cleanUp = await theaters.deleteOne({
      "location.address": newTheaterDoc.location.address,
    })

    expect(cleanUp.deletedCount).toEqual(1)
  })
})
