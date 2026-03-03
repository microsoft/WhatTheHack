describe("Basic Reads", () => {
  /**
   * In this lesson, we'll discuss how to perform query operations in MongoDB,
   * the "R" in Create, Read, Update, Delete - or CRUD.
   *
   * The first method we'll talk about is findOne. As the name suggests, findOne
   * finds one document for us and returns it.
   */

  let movies
  // all this code does is set up a handle for us to use the movies collection
  // for our CRUD operations.
  beforeAll(async () => {
    movies = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("movies")
  })

  it("findOne", async () => {
    /**
     * Let's find a document where Salma Hayek is a cast member. Because we're
     * using findOne, we'll get a single object back, which will be the first
     * match returned by the cursor. This is different than the other query
     * methods we'll use, which we'll talk about shortly.
     */

    // Our filter
    let filter = "Salma Hayek"

    // Because cast is an array, MongoDB will look at all elements of the array
    // to match this.This is because MongoDB treats arrays as first-class
    // objects.
    let result = await movies.findOne({ cast: filter })

    // we know we have a few movies where Salma Hayek is a cast member, so we
    // do not expect a null value
    expect(result).not.toBeNull()

    // we've already explored this dataset, and know that the returned movie
    // be Roadracers. Let's check the title, year, and cast.

    let { title, year, cast } = result
    console.log(result)

    // we expect a title of Roadracers, the year would be 1994, and the cast
    // includes Salma Hayek and David Arquette

    expect(title).toBe("Roadracers")
    expect(year).toBe(1994)
    expect(cast).toContain("David Arquette")

    // what if we did issue a query that resulted in no document returned? It
    // would be null

    let nullResult = await movies.findOne({ cast: "flibberty pingpang" })
    expect(nullResult).toBeNull()
  })

  // Looking at the document, we can see there is a lot of information.
  // What if we only wanted the title and year? You may be familiar with
  // projection mechanics in the mongo shell, where we might do something like
  //
  // db.movies.findOne({cast: "Salma Hayek"}, { title: 1, year: 1 })
  //
  // The Collection class also has projection functionality, but the usage is
  // different to that of the mongo shell.

  it("project", async () => {
    // We will use the same query predicate as before,
    // but only specify the fields we wish to return in the projection part of the query.
    let filter = "Salma Hayek"

    let result = await movies.findOne(
      { cast: filter },
      { projection: { title: 1, year: 1 } },
    )

    expect(result).not.toBeNull()

    // and based on the projection we except the object to have 3 keys,
    // title, year, and _id
    expect(Object.keys(result).length).toBe(3)

    console.log(result)

    // Note that only the fields we specify in the projection section of the
    // query will be returned in our result set with the exception of the _id
    // field.We need to explicitly specify when we don't want the _id field to
    // be returned. Lets try that.

    let result2 = await movies.findOne(
      { cast: filter },
      { projection: { title: 1, year: 1, _id: 0 } },
    )

    expect(result2).not.toBeNull()
    expect(Object.keys(result2).length).toBe(2)

    console.log(result2)
  })

  /**
   * Sometimes we don't want to find only one document, but all documents that
   * match our query predicate, or filter. To do that, we can use the
   * db.collection.find method instead of db.collection.findOne
   *
   * Lets build a query so that only movies with both Salma Hayek and
   * Johnny Depp are returned. For that, we'll use the $all operator
   * The $all operator will only return documents where all values specified in
   * the query are present in the array for that field. Lets look at an example.
   */

  it("all", async () => {
    // in the shell, this would be
    // db.movie.find({cast: { $all: ["Salma Hayek", "Johnny Depp"] }})
    // With the Node driver, it will look as follows.

    let result = await movies.find({
      cast: { $all: ["Salma Hayek", "Johnny Depp"] },
    })
    // very similar!

    // and we don't except a null result based on previous knowledge of this
    // dataset
    expect(result).not.toBeNull()

    let { title, year, cast } = await result.next()

    // you can see that we are using the result.next cursor method.
    // The db.collection.find() method in MongoDB returns a cursor.
    // To access the documents, you need to iterate the cursor with the .next()
    // method, or use the toArray() method.

    // The result.next method will return the next result in the cursor.
    // If there are no more results, next() resolves to null.

    // As we are movie experts and have examined this dataset, this time,
    // we expect the title of Once Upon a Time in Mexico, the year to be 2003,
    // and the cast to include Salma Hayek and Johnny Depp.

    expect(title).toBe("Once Upon a Time in Mexico")
    expect(year).toBe(2003)
    expect(cast).toContain("Johnny Depp")
    expect(cast).toContain("Salma Hayek")

    console.log({ title, year, cast })
  })
})

/**

 Let's Summarize:

 Querying MongoDB through the Driver may feel odd at first, but eventually
 it will feel like second nature.

 We saw how to retrieve one document using findOne or get all documents that
 match a query filter. We also saw how to include only the the fields we
 wanted in the result set, and how to remove the _id field.

 A few things to keep in mind:

 Finding one document typically involves querying on a unique index,
 such as the _id field.

 When projecting, by specifying inclusion (for example, title: 1) all
 fields we don't include will be excluded, except for the _id field. If
 we don't want the _id field returned to us we must explicitly exclude
 it in the projection stage.

 */
