import { MongoClient } from "mongodb"

describe("MongoClient", () => {
  /**
   * In this lesson, we'll use the MongoClient object to initiate a connection
   * with the database.
   */

  test("Client initialized with URI", async () => {
    /**
     * Here's a MongoClient object initialized with a URI string. The only
     * option we've passed is to use the new url parser in order to be
     * future compatible, so this client will have the default connection
     * parameters.
     */

    let testClient
    try {
      testClient = await MongoClient.connect(process.env.MFLIX_DB_URI, {
        useNewUrlParser: true,
      })
      expect(testClient).not.toBeNull()

      // retrieve client options
      const clientOptions = testClient.s.options
      // console.error("OPTS", clientOptions)
      expect(clientOptions).not.toBeUndefined()

      // expect this connection to have SSL enabled
      if (typeof clientOptions.ssl !== "undefined") {
        expect(clientOptions).toHaveProperty("ssl")
        expect(clientOptions.ssl).toBe(true)

        // expect this user to authenticate against the "admin" database
        expect(clientOptions).toHaveProperty("authSource")
        expect(clientOptions.authSource).toBe("admin")
      }
    } catch (e) {
      expect(e).toBeNull()
    } finally {
      testClient.close()
    }
  })

  test("Client initialized with URI and options", async () => {
    /**
     * Here we've initialized a MongoClient with a URI string, as well as a few
     * optional parameters. In this case, the parameters we set are
     * connectTimeoutMS, retryWrites and again useNewUrlParser.
     */

    let testClient
    try {
      testClient = await MongoClient.connect(process.env.MFLIX_DB_URI, {
        connectTimeoutMS: 200,
        retryWrites: true,
        useNewUrlParser: true,
      })

      const clientOptions = testClient.s.options

      // expect clientOptions to have the correct settings
      expect(clientOptions.connectTimeoutMS).toBe(200)
      expect(clientOptions.retryWrites).toBe(true)
      expect(clientOptions.useNewUrlParser).toBe(true)
    } catch (e) {
      expect(e).toBeNull()
    } finally {
      testClient.close()
    }
  })

  test("Database handle created from MongoClient", async () => {
    /**
     * Now that we have a MongoClient object, we can use it to connect to a
     * specific database. This connection is called a "database handle", and we
     * can use it to explore the database.

     * Here we're looking at the collections on this database. We want to make
     * sure that "mflix" has the necessary collections to run the application.
     */

    let testClient
    try {
      testClient = await MongoClient.connect(process.env.MFLIX_DB_URI, {
        useNewUrlParser: true,
      })

      // create a database object for the "mflix" database
      const mflixDB = testClient.db(process.env.MFLIX_NS)

      // make sure the "mflix" database has the correct collections
      const mflixCollections = await mflixDB.listCollections().toArray()
      const actualCollectionNames = mflixCollections.map(obj => obj.name)
      const expectedCollectionNames = [
        "movies",
        "users",
        "comments",
        "sessions",
      ]
      expectedCollectionNames.map(collection => {
        expect(actualCollectionNames).toContain(collection)
      })
    } catch (e) {
      expect(e).toBeNull()
    } finally {
      testClient.close()
    }
  })

  test("Collection handle created from database handle", async () => {
    /**
     * From the database handle, naturally comes the collection handle. We
     * verified in the previous test that the "mflix" database has a collection
     * called "movies". Now let's see if the "movies" collection has all the
     * data we expect.
     */

    let testClient
    try {
      testClient = await MongoClient.connect(process.env.MFLIX_DB_URI, {
        connectTimeoutMS: 200,
        retryWrites: true,
        useNewUrlParser: true,
      })

      // create a database object for the "mflix" database
      const mflixDB = testClient.db(process.env.MFLIX_NS)

      // create a collection object for the "movies" collection
      const movies = mflixDB.collection("movies")

      // expect the "movies" collection to have the correct number of movies
      const numMoves = await movies.countDocuments({})
      expect(numMoves).toBeGreaterThan(0)
    } catch (e) {
      expect(e).toBeNull()
    } finally {
      testClient.close()
    }
  })
})
