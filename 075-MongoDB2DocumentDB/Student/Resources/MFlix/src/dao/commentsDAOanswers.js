import { ObjectId } from "bson"

let comments

export default class CommentsDAO {
  static async injectDB(conn) {
    if (comments) {
      return
    }
    try {
      comments = await conn.db(process.env.MFLIX_NS).collection("comments")
    } catch (e) {
      console.error(`Unable to establish collection handles in userDAO: ${e}`)
    }
  }

  /**
  Ticket: Create/Update Comments

  For this ticket, you will need to implement the following two methods:

  - addComment
  - updateComment

  You can find these methods below this docstring. Make sure to read the comments
  to better understand the task.
  */

  /**
   * Inserts a comment into the `comments` collection, with the following fields:

     - "name", the name of the user posting the comment
     - "email", the email of the user posting the comment
     - "movie_id", the _id of the movie pertaining to the comment
     - "text", the text of the comment
     - "date", the date when the comment was posted

   * @param {string} movieId - The _id of the movie in the `movies` collection.
   * @param {Object} user - An object containing the user's name and email.
   * @param {string} comment - The text of the comment.
   * @param {string} date - The date on which the comment was posted.
   * @returns {DAOResponse} Returns an object with either DB response or "error"
   */
  static async addComment(movieId, user, comment, date) {
    try {
      // TODO Ticket: Create/Update Comments
      // Construct the comment document to be inserted into MongoDB.
      const commentDoc = {
        movie_id: ObjectId(movieId),
        name: user.name,
        email: user.email,
        text: comment,
        date: date,
      }

      return await comments.insertOne(commentDoc)
    } catch (e) {
      console.error(`Unable to post comment: ${e}`)
      return { error: e }
    }
  }

  /**
   * Updates the comment in the comment collection. Queries for the comment
   * based by both comment _id field as well as the email field to doubly ensure
   * the user has permission to edit this comment.
   * @param {string} commentId - The _id of the comment to update.
   * @param {string} userEmail - The email of the user who owns the comment.
   * @param {string} text - The updated text of the comment.
   * @param {string} date - The date on which the comment was updated.
   * @returns {DAOResponse} Returns an object with either DB response or "error"
   */
  static async updateComment(commentId, userEmail, text, date) {
    try {
      // TODO Ticket: Create/Update Comments
      // Use the commentId and userEmail to select the proper comment, then
      // update the "text" and "date" fields of the selected comment.
      const updateResponse = await comments.updateOne(
        { _id: commentId, email: userEmail },
        { $set: { text: text, date: date } },
      )

      return updateResponse
    } catch (e) {
      console.error(`Unable to update comment: ${e}`)
      return { error: e }
    }
  }

  static async deleteComment(commentId, userEmail) {
    /**
    Ticket: Delete Comments

    Implement the deleteOne() call in this method.

    Ensure the delete operation is limited so only the user can delete their own
    comments, but not anyone else's comments.
    */

    try {
      // TODO Ticket: Delete Comments
      // Use the userEmail and commentId to delete the proper comment.
      const deleteResponse = await comments.deleteOne({
        _id: ObjectId(commentId),
        email: userEmail,
      })

      return deleteResponse
    } catch (e) {
      console.error(`Unable to delete comment: ${e}`)
      return { error: e }
    }
  }

  static async mostActiveCommenters() {
    /**
    Ticket: User Report

    Build a pipeline that returns the 20 most frequent commenters on the MFlix
    site. You can do this by counting the number of occurrences of a user's
    email in the `comments` collection.
    */
    try {
      // TODO Ticket: User Report
      // Return the 20 users who have commented the most on MFlix.
      const pipeline = [
        {
          $sortByCount: "$email",
        },
        {
          $limit: 20,
        },
      ]

      // TODO Ticket: User Report
      // Use a more durable Read Concern here to make sure this data is not stale.
      const readConcern = "majority"

      const aggregateResult = await comments.aggregate(pipeline, {
        readConcern,
      })

      return await aggregateResult.toArray()
    } catch (e) {
      console.error(`Unable to retrieve most active commenters: ${e}`)
      return { error: e }
    }
  }
}

/**
 * Success/Error return object
 * @typedef DAOResponse
 * @property {boolean} [success] - Success
 * @property {string} [error] - Error
 */
