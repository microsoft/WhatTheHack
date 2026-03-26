import MoviesDAO from "../src/dao/moviesDAO"

describe("Facets", () => {
  beforeAll(async () => {
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("should require cast members to perform search with", async () => {
    const filters = {}
    expect(async () => await MoviesDAO.facetedSearch(filters).toThrow())
  })

  test("should return movies and runtime/rating facets for returned movies", async () => {
    const filters = { cast: { $in: ["Tom Hanks"] } }
    const actual = await MoviesDAO.facetedSearch({ filters })
    expect(actual.movies.length).toBe(20)
    expect(actual.rating.length).toBe(5)
    expect(actual.runtime.length).toBe(4)
    expect(actual.count).toBe(37)
  })

  test("should also support paging", async () => {
    const filters = { cast: { $in: ["Susan Sarandon"] } }
    const actual = await MoviesDAO.facetedSearch({ filters, page: 1 })
    expect(actual.movies.length).toBe(18)
    expect(actual.rating.length).toBe(3)
    expect(actual.runtime.length).toBe(4)
    expect(actual.count).toBe(38)
  })

  test("should throw an error if castMembers is empty", async () => {
    const filters = { cast: { $in: [] } }
    expect(async () => await MoviesDAO.facetedSearch({ filters }).toThrow())
  })
})
