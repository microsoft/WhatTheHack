import { ObjectId } from "bson"
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

// Interstellar
const movieId = "573a13b9f29313caabd4ddff"

const date = new Date()

let comment = {
  text: "fa-fe-fi-fo-fum",
  id: "",
}

const newCommentText = "foo foo foo"

const newerCommentText = "bar bar bar"

describe("Create/Update Comments", () => {
  beforeAll(async () => {
    await CommentsDAO.injectDB(global.mflixClient)
    await MoviesDAO.injectDB(global.mflixClient)
  })

  afterAll(async () => {
    const commentsCollection = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("comments")
    const deleteResult = await commentsCollection.deleteMany({
      text: "fa-fe-fi-fo-fum",
    })
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

    const movieComments = (await MoviesDAO.getMovieByID(movieId)).comments

    expect(movieComments[0]._id).toEqual(postCommentResult.insertedId)
    expect(movieComments[0].text).toEqual(comment.text)

    comment.id = postCommentResult.insertedId
  })

  test("Can update a comment", async () => {
    const updateCommentResult = await CommentsDAO.updateComment(
      comment.id,
      testUser.email,
      newCommentText,
      date,
    )
    expect(updateCommentResult.modifiedCount).toBe(1)

    const movieComments = (await MoviesDAO.getMovieByID(movieId)).comments

    expect(movieComments[0].text).toBe(newCommentText)
  })

  test("Can only update comment if user posted comment", async () => {
    const updateCommentResult = await CommentsDAO.updateComment(
      comment.id,
      newUser.email,
      newerCommentText,
      date,
    )

    expect(updateCommentResult.modifiedCount).toBe(0)
  })
})
