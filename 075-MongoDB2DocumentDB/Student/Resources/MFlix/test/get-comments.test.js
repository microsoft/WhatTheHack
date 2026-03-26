import MoviesDAO from "../src/dao/moviesDAO"

describe("Get Comments", () => {
  beforeAll(async () => {
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("Can fetch comments for a movie", async () => {
    const id = "573a13b5f29313caabd42c2f"
    const movie = await MoviesDAO.getMovieByID(id)
    expect(movie.title).toEqual("The Express")
    expect(movie.comments.length).toBe(147)
  })

  test("comments should be sorted by date", async () => {
    // most recent to least
    expect.assertions(10)
    const movieIds = ["573a13b5f29313caabd42c2f"]
    const promises = movieIds.map(async id => {
      const movie = await MoviesDAO.getMovieByID(id)
      const comments = movie.comments
      const sortedComments = comments.slice()
      sortedComments.sort((a, b) => b.date.getTime() - a.date.getTime())

      for (let i = 0; i < Math.min(10, comments.length); i++) {
        const randomInt = Math.floor(Math.random() * comments.length - 1)
        expect(comments[randomInt]).toEqual(sortedComments[randomInt])
      }
    })
    await Promise.all(promises)
  })
})
