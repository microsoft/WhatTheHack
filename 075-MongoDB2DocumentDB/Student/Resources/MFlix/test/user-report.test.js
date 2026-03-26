import CommentsDAO from "../src/dao/commentsDAO"

describe("User Report", () => {
  beforeAll(async () => {
    await CommentsDAO.injectDB(global.mflixClient)
  })

  test("Should return exactly twenty results", async () => {
    const userReport = await CommentsDAO.mostActiveCommenters()
    expect(userReport.length).toBe(20)
  })

  test("Should return correct comment totals", async () => {
    const userReport = await CommentsDAO.mostActiveCommenters()
    const topCommenter = userReport[0]
    expect(topCommenter._id).toEqual("roger_ashton-griffiths@gameofthron.es")
    expect(topCommenter.count).toBeGreaterThan(0)
  })
})
