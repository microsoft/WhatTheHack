import CommentsDAO from "../src/dao/commentsDAO"
import MoviesDAO from "../src/dao/moviesDAO"

const testUser = {
  name: "foobar",
  email: "foobar@baz.com",
}

const newUser = {
  name: "barfoo",
  email: "baz@foobar.com",
}

// this is the movieId for "King Kong"
const movieId = "573a1392f29313caabcd9f92"

const date = new Date()

let comment = {
  text: "fe-fi-fo-fum",
  id: "",
}

describe("Delete Comments", () => {
  beforeAll(async () => {
    await CommentsDAO.injectDB(global.mflixClient)
    await MoviesDAO.injectDB(global.mflixClient)
  })

  test("Can post a comment", async () => {
    const postCommentResult = await CommentsDAO.addComment(
      movieId,
      testUser,
      comment.text,
      date,
    )

    expect(postCommentResult.insertedCount).toBe(1)
    expect(postCommentResult.insertedId).not.toBe(null)

    const kingKongComments = (await MoviesDAO.getMovieByID(movieId)).comments

    expect(kingKongComments[0]._id).toEqual(postCommentResult.insertedId)
    expect(kingKongComments[0].text).toEqual(comment.text)

    comment.id = postCommentResult.insertedId
  })

  test("Cannot delete a comment if email does not match", async () => {
    const deleteCommentResult = await CommentsDAO.deleteComment(
      comment.id,
      newUser.email,
    )

    expect(deleteCommentResult.deletedCount).toBe(0)
  })

  test("Can delete a comment if email matches", async () => {
    const deleteCommentResult = await CommentsDAO.deleteComment(
      comment.id,
      testUser.email,
    )

    expect(deleteCommentResult.deletedCount).toBe(1)
  })
})
