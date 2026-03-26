import { ObjectId } from "mongodb"
describe("Basic Writes", () => {
  /**
   * In this lesson, we'll discuss how to perform write operations in MongoDB,
   * the "C" and "U" in Create, Read, Update, Delete
   *
   * The first method we'll talk about is insertOne. insertOne inserts one
   * document into the database.
   */

  let videoGames
  // for this lesson we're creating a new collection called videoGames
  beforeAll(async () => {
    videoGames = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("videoGames")
  })

  // and after all the tests run, we'll drop this collection
  afterAll(async () => {
    await videoGames.drop()
  })

  it("insertOne", async () => {
    /**
     * Let's insert a document with the title Fortnite and a year of 2018
     */
    let insertResult = await videoGames.insertOne({
      title: "Fortnite",
      year: 2018,
    })
    // when we insert a document, we get an insertOneWriteOpResult
    // one of its properties is result. n is the total documents inserted
    // and ok means the database responded that the command executed correctly
    let { n, ok } = insertResult.result
    expect({ n, ok }).toEqual({ n: 1, ok: 1 })
    // it also contains an insertedCount key, which should be the same as n
    // above
    expect(insertResult.insertedCount).toBe(1)
    // the last property we'll talk about on it is insertedId
    // if we don't specify an _id when we write to the database, MongoDB will
    // insert one for us and return this to us here
    expect(insertResult.insertedId).not.toBeUndefined()
    console.log("inserted _id", insertResult.insertedId)

    // let's ensure that we can find document we just inserted with the
    // insertedId we just received
    let { title, year } = await videoGames.findOne({
      _id: ObjectId(insertResult.insertedId),
    })
    expect({ title, year }).toEqual({ title: "Fortnite", year: 2018 })

    // and what if we tried to insert a document with the same _id?
    try {
      let dupId = await videoGames.insertOne({
        _id: insertResult.insertedId,
        title: "Foonite",
        year: 2099,
      })
    } catch (e) {
      expect(e).not.toBeUndefined()
      // we get an error message stating we've tried to insert a duplicate key
      expect(e.errmsg).toContain("E11000 duplicate key error collection")
    }
  })
  it("insertMany", async () => {
    /**
     * The insertOne method is useful, but what if we want to insert more than
     * one document at a time? The preferred method for that is insertMany
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

    // Creating documents to insert based on the megaManYears array above
    let docs = megaManYears.map((year, idx) => ({
      title: `Mega Man ${idx + 1}`,
      year,
    }))

    // now let's insert these into the database
    let insertResult = await videoGames.insertMany(docs)

    // just like insertOne, we'll get a result object back that has information
    // like the number of documents inserted and the inserted _ids
    expect(insertResult.insertedCount).toBe(10)
    expect(Object.values(insertResult.insertedIds).length).toBe(10)
    // and we can see what the insertIds were
    console.log(Object.values(insertResult.insertedIds))
  })
  /**
   * Inserting is a useful write operation, but it's very simple. It inserts
   * new data into the database without regard for what the new data is, or
   * what's already in the database as as long as we don't specify a duplicate
   * _id.
   *
   * So what happens if we want to insert a document, but we're not sure if it's
   * already in the database? We could do a find to check, but that's
   * inefficient when we have the ability to upsert.
   */
  it("upsert", async () => {
    // this is an upsert. We use the update method instead of insert.
    let upsertResult = await videoGames.updateOne(
      // this is the "query" portion of the update
      { title: "Call of Duty" },
      // this is the update
      {
        $set: {
          title: "Call of Duty",
          year: 2003,
        },
      },
      // this is the options document. We've specified upsert: true, so if the
      // query doesn't find a document to update, it will be written instead as
      // a new document
      { upsert: true },
    )

    // we don't expect any documents to have been modified
    expect(upsertResult.result.nModified).toBe(0)
    // and here's the information that the result.upserted key contains
    // an _id and an index
    console.log(upsertResult.result.upserted)

    // what if the document existed?
    upsertResult = await videoGames.updateOne(
      { title: "Call of Duty" },
      // we'll update the year to 2018
      {
        $set: {
          title: "Call of Duty",
          year: 2018,
        },
      },
      { upsert: true },
    )
    // we can see the second upsert result does not have an upserted key
    console.log("second upsert result", upsertResult.result)
    expect(upsertResult.result.nModified).toBe(1)

    // upserts are useful, especially when we can make a write operation
    // generic enough that updating or inserting should give the same result
    // to our application
  })
})

/**
 * Let's Summarize:
 *
 * The two idiomatic methods for inserting documents are insertOne and
 * insertMany
 *
 * Trying to insert a duplicate _id will fail
 *
 * As an alternative to inserting, we can specify an upsert in an update
 * operation
 */
