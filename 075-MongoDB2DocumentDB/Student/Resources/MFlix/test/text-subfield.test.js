import MoviesDAO from "../src/dao/moviesDAO"

describe("Text and Subfield Search", () => {
  beforeAll(async () => {
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("Can perform a text search", async () => {
    const filters = { text: "mongo" }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
    })
    expect(moviesList.length).toBeGreaterThan(0)
    expect(totalNumMovies).toBeGreaterThan(0)
    const firstMovie = moviesList[0]
    expect(firstMovie["title"]).toBeTruthy()
  })

  test("Can perform a genre search with one genre", async () => {
    const filters = { genre: ["Action"] }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
    })
    expect(moviesList.length).toEqual(20)
    expect(totalNumMovies).toBeGreaterThan(0)
    const firstMovie = moviesList[0]
    expect(firstMovie["title"]).toBeTruthy()
  })

  test("Can perform a genre search with multiple genres", async () => {
    const filters = { genre: ["Mystery", "Thriller"] }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
    })
    expect(moviesList.length).toEqual(20)
    expect(totalNumMovies).toBeGreaterThan(0)
    const firstMovie = moviesList[0]
    expect(firstMovie["title"]).toBeTruthy()
  })

  test("Can perform a cast search with one cast member", async () => {
    const filters = { cast: ["Elon Musk"] }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
    })
    expect(moviesList.length).toBeGreaterThanOrEqual(1)
    expect(totalNumMovies).toBeGreaterThanOrEqual(1)
    const firstMovie = moviesList[0]
    expect(firstMovie["title"]).toBeTruthy()
  })

  test("Can perform a cast search with multiple cast members", async () => {
    const filters = { cast: ["Robert Redford", "Julia Roberts"] }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
    })
    expect(moviesList.length).toEqual(20)
    expect(totalNumMovies).toBeGreaterThan(20)
    const lastMovie = moviesList.slice(-1).pop()
    expect(lastMovie["title"]).toBeTruthy()
  })

  test("Can perform a search and return a non-default number of movies per page", async () => {
    const filters = { cast: ["Robert Redford", "Julia Roberts"] }
    const { moviesList, totalNumMovies } = await MoviesDAO.getMovies({
      filters,
      moviesPerPage: 33,
    })
    expect(moviesList.length).toEqual(33)
    expect(totalNumMovies).toBeGreaterThan(33)
    const lastMovie = moviesList.slice(-1).pop()
    expect(lastMovie["title"]).toBeTruthy()
  })
})
