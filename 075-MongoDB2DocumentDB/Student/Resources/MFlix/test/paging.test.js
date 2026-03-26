import MoviesDAO from "../src/dao/moviesDAO"

describe("Paging", () => {
  beforeAll(async () => {
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("Supports paging by cast", async () => {
    const filters = { cast: ["Natalie Portman"] }
    /**
     * Testing first page
     */
    const { moviesList: firstPage, totalNumMovies } = await MoviesDAO.getMovies(
      {
        filters,
      },
    )

    // check the total number of movies, including both pages
    expect(totalNumMovies).toBeGreaterThan(0)

    // check the number of movies on the first page
    expect(firstPage.length).toEqual(20)

    const firstMovie = firstPage[0]
    expect(firstMovie.title).toBeTruthy()

    /**
     * Testing second page
     */
    const { moviesList: secondPage } = await MoviesDAO.getMovies({
      filters,
      page: 1,
    })

    // check the number of movies on the second page
    expect(secondPage.length).toBeGreaterThanOrEqual(0)
    if (totalNumMovies > 20) {
      expect(secondPage.length).toBeGreaterThan(0)
    }
  })

  test("Supports paging by genre", async () => {
    const filters = { genre: ["Comedy", "Drama"] }

    /**
     * Testing first page
     */
    const { moviesList: firstPage, totalNumMovies } = await MoviesDAO.getMovies(
      {
        filters,
      },
    )

    // check the total number of movies, including both pages
    expect(totalNumMovies).toBeGreaterThan(0)

    // check the number of movies on the first page
    expect(firstPage.length).toEqual(20)

    const firstMovie = firstPage[0]
    expect(firstMovie.title).toBeTruthy()

    /**
     * Testing second page
     */
    const { moviesList: secondPage } = await MoviesDAO.getMovies({
      filters,
      page: 1,
    })

    // check the number of movies on the second page
    expect(secondPage.length).toEqual(20)
    const twentyFirstMovie = secondPage[0]
    expect(twentyFirstMovie.title).toBeTruthy()
  })

  test("Supports paging by text", async () => {
    const filters = { text: "countdown" }

    /**
     * Testing first page
     */
    const { moviesList: firstPage, totalNumMovies } = await MoviesDAO.getMovies(
      {
        filters,
      },
    )

    // check the total number of movies, including both pages
    expect(totalNumMovies).toBeGreaterThanOrEqual(0)

    // check the number of movies on the first page
    expect(firstPage.length).toBeLessThanOrEqual(20)

    if (firstPage.length > 0) {
      const firstMovie = firstPage[0]
      expect(firstMovie.title).toBeTruthy()
    }

    /**
     * Testing second page
     */
    const { moviesList: secondPage } = await MoviesDAO.getMovies({
      filters,
      page: 1,
    })

    // check the number of movies on the second page
    if (totalNumMovies <= 20) {
      expect(secondPage.length).toEqual(0)
    }
  })
})
