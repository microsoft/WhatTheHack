import { MongoClient } from "mongodb"

let movies
describe("Cursor Methods and Aggregation Equivalents", () => {
  /**
   * In this lesson, we'll discuss the methods we can call against MongoDB
   * cursors, and the aggregation stages that would perform the same tasks in a
   * pipeline.
   */

  beforeAll(async () => {
    /**
     * Here we're just establishing a connection to the database, and creating a
     * handle for the movies collection.
     *
     * We wrapped this in a try/catch block, in case there's a network error, or
     * some other issue.
     */
    try {
      movies = await global.mflixClient
        .db(process.env.MFLIX_NS)
        .collection("movies")
    } catch (e) {
      console.error(
        `Unable to establish a collection handle for "mflix.movies": ${e}`,
      )
    }
  })

  test("Can limit the number of results returned by a cursor", async () => {
    /**
     * We're looking for movies that Sam Raimi directed, but we don't need ALL
     * the movies he directed - we only want a couple of them.
     *
     * Because Sam Raimi directed more than 2 movies in this collection, the
     * .limit(2) will return only 2 results. Similarly, .limit(10) will only
     * return 10 results, and so on.
     */
    const limitedCursor = movies
      .find({ directors: "Sam Raimi" }, { _id: 0, title: 1, cast: 1 })
      .limit(2)

    // expect this cursor to contain exactly 2 results
    expect((await limitedCursor.toArray()).length).toEqual(2)
  })

  test("Can limit the number of results returned by a pipeline", async () => {
    /**
     * We can also limit the number of results returned by a pipeline, by adding
     * a $limit stage in our aggregation.
     *
     * This pipeline should return only 2 results.
     */
    const limitPipeline = [
      { $match: { directors: "Sam Raimi" } },
      { $project: { _id: 0, title: 1, cast: 1 } },
      { $limit: 2 },
    ]

    const limitedAggregation = await movies.aggregate(limitPipeline)

    expect((await limitedAggregation.toArray()).length).toEqual(2)
  })

  test("Can sort the results returned by a cursor", async () => {
    /**
     * By default, the results in a cursor are sorted in "natural" order - this
     * order is an internal implementation, and often has no particular
     * structure.
     *
     * To sort our results in a more structured way, we can choose a key and a
     * sort order, then use .sort() to return the results accordingly.
     *
     * The "year" field denotes the release date of each movie, so the
     * .sort([["year", 1]]) will sort our results on the "year" key, in
     * ascending order. Conversely, .sort([["year", -1]]) would return them in
     * descending order.
     */
    const sortedCursor = movies
      .find({ directors: "Sam Raimi" }, { _id: 0, year: 1, title: 1, cast: 1 })
      .sort([["year", 1]])

    const movieArray = await sortedCursor.toArray()

    // expect each movie in our cursor to be newer than the next movie in the
    // cursor
    for (var i = 0; i < movieArray.length - 1; i++) {
      let movie = movieArray[i]
      let nextMovie = movieArray[i + 1]
      expect(movie.year).toBeLessThanOrEqual(nextMovie.year)
    }
  })

  test("Can sort the results returned by a pipeline", async () => {
    /**
     * We can also sort the results returned by a pipeline, by adding a $sort
     * stage in our aggregation. In the Aggregation Framework, we say
     * { $sort: { year: 1 } } instead of .sort([["year", 1]]).
     *
     * This pipeline should sort our results by year, in ascending order.
     */
    const sortPipeline = [
      { $match: { directors: "Sam Raimi" } },
      { $project: { _id: 0, year: 1, title: 1, cast: 1 } },
      { $sort: { year: 1 } },
    ]

    const sortAggregation = await movies.aggregate(sortPipeline)
    const movieArray = await sortAggregation.toArray()

    for (var i = 0; i < movieArray.length - 1; i++) {
      let movie = movieArray[i]
      let nextMovie = movieArray[i + 1]
      expect(movie.year).toBeLessThanOrEqual(nextMovie.year)
    }
  })

  test("Can skip through results in a cursor", async () => {
    /**
     * Sometimes we don't need all the results in a cursor. Especially when the
     * results in the cursor are sorted, we can skip a few results to retrieve
     * just the results that we need.
     *
     * To skip through results in a cursor, we can use the .skip() method with
     * an integer denoting how many documents to skip. For example, skip(5) will
     * skip the first 5 documents in a cursor, and only return the documents
     * that appear after those first 5.

     * Given that we are sorting on year in ascending order, the .skip(5) will
     * skip the 5 oldest movies that Sam Raimi directed, and only return the
     * more recent movies.
     */
    const skippedCursor = movies
      .find({ directors: "Sam Raimi" }, { _id: 0, year: 1, title: 1, cast: 1 })
      .sort([["year", 1]])
      .skip(5)

    const regularCursor = movies
      .find({ directors: "Sam Raimi" }, { _id: 0, year: 1, title: 1, cast: 1 })
      .sort([["year", 1]])

    // expect the skipped cursor to contain the same results as the regular
    // cursor, minus the first five results
    expect(await skippedCursor.toArray()).toEqual(
      (await regularCursor.toArray()).slice(5),
    )
  })

  test("Can skip through results in a pipeline", async () => {
    /**
     * We can also skip through the results returned by a pipeline, by adding a
     * $skip stage in our aggregation.
     *
     * This pipeline should sort our results by year, in ascending order, and
     * then skip the 5 oldest movies.
     */
    const skippedPipeline = [
      { $match: { directors: "Sam Raimi" } },
      { $project: { _id: 0, year: 1, title: 1, cast: 1 } },
      { $sort: { year: 1 } },
      { $skip: 5 },
    ]

    const regularPipeline = [
      { $match: { directors: "Sam Raimi" } },
      { $project: { _id: 0, year: 1, title: 1, cast: 1 } },
      { $sort: { year: 1 } },
    ]

    const skippedAggregation = await movies.aggregate(skippedPipeline)
    const regularAggregation = await movies.aggregate(regularPipeline)

    expect(await skippedAggregation.toArray()).toEqual(
      (await regularAggregation.toArray()).slice(5),
    )
  })
})
