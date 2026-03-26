import MoviesDAO from "../src/dao/moviesDAO"
import { ObjectId } from "mongodb"

describe("Migration", () => {
  beforeAll(async () => {
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("migration", async () => {
    const movie = await MoviesDAO.movies.findOne({
      _id: ObjectId("573a1391f29313caabcd7a34"),
      lastupdated: { $type: "date" },
    })
    expect(movie).not.toBeNull()
  })
})
