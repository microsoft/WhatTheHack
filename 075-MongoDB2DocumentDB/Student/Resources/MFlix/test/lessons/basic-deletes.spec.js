describe("Basic Deletes", () => {
  /**
   * In this lesson, we'll discuss how to perform delete operations in MongoDB.
   *
   * The first method we'll talk about is deleteOne. Before we do this, we need
   * to create a collection and insert some documents into it.
   */

  let videoGames
  // As with our updates lesson,  we're creating a new collection called videoGames
  beforeAll(async () => {
    videoGames = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("videoGames")
  })

  // and then after all the tests run, we'll drop this collection
  afterAll(async () => {
    await videoGames.drop()
  })

  it("insertMany", async () => {
    /**
     * First, let's insert documents into this collection so that we can delete
     * them during this lesson.
     */

    let megaManYears = [
      1987,
      1988,
      1990,
      1991,
      1992,
      1993,
      1995,
      1996,
      2008,
      2010,
    ]

    // Here we are creating documents to insert based on the megaManYears array above
    let docs = megaManYears.map((year, idx) => ({
      title: "Mega Man",
      year,
    }))

    // now let's insert these into the database
    let insertResult = await videoGames.insertMany(docs)

    // Let's check that our documents are present.
    expect(insertResult.insertedCount).toBe(10)
    expect(Object.values(insertResult.insertedIds).length).toBe(10)
    // and we can see what the insertIds were
    console.log(Object.values(insertResult.insertedIds))
  })

  it("deleteOne", async () => {
    /**
    Now let's try to delete a document using deleteOne()
    The first thing to understand is that a delete operation is in fact
    a write in database world. Confused? What I mean by this is that
    when we delete a document from our database we are actually
    executing a state change in the data, that implies a database write
    Deletes imply that several different things will happen:
    - collection data will be changed
    - indexes will be updated
    - entries in the oplog (replication mechanism) will be added.

    All the same operations that an insert or an update would originate.

    But let's go ahead and see this in action with a single document
    delete.

    Before I start deleting data from my collection I'm going to count
    the number of documents in the sports collection.
    */

    let countDocumentsBefore = await videoGames.count({})

    // We will then delete a document without specifying any query predicates using deleteOne()
    let deleteDocument = await videoGames.deleteOne({})

    // To check that our delete was successful, we can check that result.n is
    // equal to 1. This is an object returned by the MongoDB Javascript driver
    // which will tell the client if a delete has been successful or not.
    // Let's test to see if the delete was successful.

    expect(deleteDocument.result.n).toBe(1)

    // Great. That's what we expected!

    // If we now count the number of documents remaining in our collection, we
    // should see that there is one less than we inserted

    let countDocuments = await videoGames.count({})

    console.log(
      `collection had ${countDocumentsBefore} documents, now has ${countDocuments}`,
    )

    // We just did our first delete.
  })

  // All good. As expected.

  // Wait, but which document did I just remove from the collection?
  // Well, in this case MongoDB will select the first $natural document
  // it encounters in the collection and delete that one.
  // Given that the insertMany inserts documents in order, the document
  // that I have just deleted will be the one with year = 1987.

  it("deletewithPredicate", async () => {
    /**
     * A delete that takes the first element of the collection $natural
     * order tends to be a less than usual thing that you would do in your
     * application, so let's use something a bit more elaborate.
     * Let's say I would like to delete a document that matches a
     * particular year.
     */

    let deleteDocument = await videoGames.deleteOne({ year: 2008 })

    // To check that our delete was successful, we'll check the result.n object.

    expect(deleteDocument.result.n).toBe(1)

    // If we now count the number of documents remaining in our we should see
    // that there is one less than we inserted
    let countDocuments = await videoGames.count({})

    console.log(countDocuments)
    // All good. As expected.
  })

  // Next, we will use the deleteMany operator. As the name suggests, this
  // operator allows us to delete many documents, which match a given filter in
  // our delete statement. Let's check it out:
  it("deleteMany", async () => {
    // let's see how many documents are left in the collection before we use
    // the deleteMany operator.
    let countDocuments = await videoGames.count({})
    expect(countDocuments).toEqual(8)

    // Now let's try to delete multiple documents using deleteMany().
    // To do this, we will need to specify a filter for the delete statement
    // that will match multiple documents.
    let deleteManyDocs = await videoGames.deleteMany({ year: { $lt: 1993 } })

    // This will delete all documents that have a year before 1993.
    // To check that our delete was successful, we can check what the value of
    // deleteMayDocs.result.n is equal to. In this case, we expect it to be 4.
    expect(deleteManyDocs.result.n).toBe(4)

    let findResult = await videoGames.find({})
    let findResultArray = await findResult.toArray()

    // After the delete operation, we expect all the documents to have a year
    // greater than or equal to 1993.
    for (var i = 0; i < findResultArray.length - 1; i++) {
      let videoGame = findResultArray[i]
      expect(videoGame.year).toBeGreaterThanOrEqual(1993)
    }

    countDocuments = await videoGames.count({})
    expect(countDocuments).toEqual(4)
  })
})
