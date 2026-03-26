import { ObjectId } from "mongodb"
describe("Error Handling", () => {
  /* Hello!
   * In this lesson we are going to talk about Error Handling. We will cover a
   * few different kinds of errors and discuss ways to handle them gracefully.
   *
   * This way can ensure that our application is resilient to issues that can
   * occur in concurrent and distributed systems.
   *
   * Distributed systems are prone to network issues, while concurrent systems
   * will more likely encounter duplicate key errors.
   *
   * While the errors covered in this lesson aren't very likely to occur, it is
   * helpful to know how to deal with them if and when they manifest themselves.
   */

  let errors
  // for this lesson we're creating a new collection called errors to work with.
  beforeAll(async () => {
    errors = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("errors")
  })

  // and after all the tests run, we'll drop this collection
  afterAll(async () => {
    await errors.drop()
  })

  it("duplicateKey", async () => {
    /**
     * add one document to the "errors" database with the _id value set to 0
     */
    let insertResult = await errors.insertOne({
      _id: 0,
    })

    /* The first common error can occur when you are trying to insert a document
     * in place of an already existing document. In our example there is already
     * a document with _id that equals 0, so inserting another document with the
     * same _id value should cause a duplicate key error.
     *
     * Let's test to see if this is true.
     *
     * In this test case we are specifying that we are expecting to get a
     * Duplicate Key error.
     */

    let { n, ok } = insertResult.result
    expect({ n, ok }).toEqual({ n: 1, ok: 1 })
    // Let's check that the document was successfully inserted.
    expect(insertResult.insertedCount).toBe(1)

    // and what if we tried to insert a document with the same _id?
    try {
      let dupId = await errors.insertOne({
        _id: 0,
      })
    } catch (e) {
      expect(e).not.toBeUndefined()
      // we get an error message stating we've tried to insert a duplicate key
      expect(e.errmsg).toContain("E11000 duplicate key error collection")
      console.log(e)
    }
  })

  /* Great! It looks like the test passed, but it would be great to know
   * exactly what kind of error we are getting. In this test case you can see
   * that the error returned is the Duplicate Key error, which means that in
   * order to correct it we should not be trying to insert a Document with an
   * existing key.
   *
   * Simply changing the key value should do the trick.
   */
  it("avoids duplicateKey", async () => {
    try {
      let notdupId = await errors.insertOne({
        _id: 3,
      })
    } catch (e) {
      expect(e).toBeUndefined()
    }
  })

  /* Another error to be on the lookout for is the timeout error. In this test
   * case we are trying to avoid breaking the application by using the try/catch
   * block.
   *
   * This particular test case won't cause a timeout error. In fact, it is very
   * hard to induce a timeout error or any of the errors covered in this lesson
   * on an application that is running on Atlas.
   *
   * But if that does happen, then a try/catch block will help you identify the
   * situation.
   *
   * To fix a timeout issue you need to consider the needs of your application,
   * and depending on that you can either reduce durability guarantees by
   * lowering the write concern value or increase the timeout and keep the app
   * durable.
   */

  it("timeout", async () => {
    try {
      let dupId = await errors.insertOne(
        {
          _id: 6,
        },
        { wtimeoutMS: 1 },
      )
    } catch (e) {
      expect(e).toBeUndefined()
    }
  })

  /*
   *
   * Another possible error can occur when the write concern that is
   * requested cannot be fulfilled.
   *
   * For example, our replica set has 3 nodes that was automatically created by
   * Atlas. We can dictate the type of write concern that we want for our write
   * operations. In the example below we are asking for a 5 node
   * acknowledgement, which is impossible in our situation. As a result we get a
   * Write Concern Exception.
   *
   * This error is easy to solve by either assigning a majority write concern or
   * a number that is less than or equal to 3.
   *
   */

  it("WriteConcernError", async () => {
    try {
      let dupId = await errors.insertOne(
        {
          _id: 6,
        },
        { w: 5 },
      )
    } catch (e) {
      expect(e).not.toBeNull()
      // Now let's check the error that was returned from the driver.
      console.log(e)
    }
  })
})

// That's it for our lesson on error handling. Enjoy the rest of the course!
