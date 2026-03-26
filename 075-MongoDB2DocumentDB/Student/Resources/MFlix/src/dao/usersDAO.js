let users
let sessions

export default class UsersDAO {
  static async injectDB(conn) {
    if (users && sessions) {
      return
    }
    try {
      users = await conn.db(process.env.MFLIX_NS).collection("users")
      sessions = await conn.db(process.env.MFLIX_NS).collection("sessions")
    } catch (e) {
      console.error(`Unable to establish collection handles in userDAO: ${e}`)
    }
  }

  /**
  Ticket: User Management

  For this ticket, you will need to implement the following five methods:

  - getUser
  - addUser
  - loginUser
  - logoutUser
  - getUserSession

  You can find these methods below this comment. Make sure to read the comments
  in each method to better understand the implementation.

  The method deleteUser is already given to you.
  */

  /**
   * Finds a user in the `users` collection
   * @param {string} email - The email of the desired user
   * @returns {Object | null} Returns either a single user or nothing
   */
  static async getUser(email) {
    // TODO Ticket: User Management
    // Retrieve the user document corresponding with the user's email.
    return await users.findOne({ email })
  }

  /**
   * Adds a user to the `users` collection
   * @param {UserInfo} userInfo - The information of the user to add
   * @returns {DAOResponse} Returns either a "success" or an "error" Object
   */
  static async addUser(userInfo) {
    /**
    Ticket: Durable Writes

    Please increase the durability of this method by using a non-default write
    concern with ``insertOne``.
    */

    try {
      // TODO Ticket: User Management
      // Insert a user with the "name", "email", and "password" fields.
      // TODO Ticket: Durable Writes
      // Use a more durable Write Concern for this operation.
      const { name, email, password } = userInfo
      await users.insertOne({ name, email, password }, { w: "majority" })
      return { success: true }
    } catch (e) {
      const errorMessage = String(e)
      if (
        errorMessage.includes("E11000") ||
        errorMessage.toLowerCase().includes("duplicate key")
      ) {
        return { error: "A user with the given email already exists." }
      }
      console.error(`Error occurred while adding new user, ${e}.`)
      return { error: e }
    }
  }

  /**
   * Adds a user to the `sessions` collection
   * @param {string} email - The email of the user to login
   * @param {string} jwt - A JSON web token representing the user's claims
   * @returns {DAOResponse} Returns either a "success" or an "error" Object
   */
  static async loginUser(email, jwt) {
    try {
      // TODO Ticket: User Management
      // Use an UPSERT statement to update the "jwt" field in the document,
      // matching the "user_id" field with the email passed to this function.
      await sessions.updateOne(
        { user_id: email },
        { $set: { jwt } },
        { upsert: true },
      )
      return { success: true }
    } catch (e) {
      console.error(`Error occurred while logging in user, ${e}`)
      return { error: e }
    }
  }

  /**
   * Removes a user from the `sessons` collection
   * @param {string} email - The email of the user to logout
   * @returns {DAOResponse} Returns either a "success" or an "error" Object
   */
  static async logoutUser(email) {
    try {
      // TODO Ticket: User Management
      // Delete the document in the `sessions` collection matching the email.
      await sessions.deleteOne({ user_id: email })
      return { success: true }
    } catch (e) {
      console.error(`Error occurred while logging out user, ${e}`)
      return { error: e }
    }
  }

  /**
   * Gets a user from the `sessions` collection
   * @param {string} email - The email of the user to search for in `sessions`
   * @returns {Object | null} Returns a user session Object, an "error" Object
   * if something went wrong, or null if user was not found.
   */
  static async getUserSession(email) {
    try {
      // TODO Ticket: User Management
      // Retrieve the session document corresponding with the user's email.
      return sessions.findOne({ user_id: email })
    } catch (e) {
      console.error(`Error occurred while retrieving user session, ${e}`)
      return null
    }
  }

  /**
   * Removes a user from the `sessions` and `users` collections
   * @param {string} email - The email of the user to delete
   * @returns {DAOResponse} Returns either a "success" or an "error" Object
   */
  static async deleteUser(email) {
    try {
      await users.deleteOne({ email })
      await sessions.deleteOne({ user_id: email })
      if (!(await this.getUser(email)) && !(await this.getUserSession(email))) {
        return { success: true }
      } else {
        console.error(`Deletion unsuccessful`)
        return { error: `Deletion unsuccessful` }
      }
    } catch (e) {
      console.error(`Error occurred while deleting user, ${e}`)
      return { error: e }
    }
  }

  /**
   * Given a user's email and an object of new preferences, update that user's
   * data to include those preferences.
   * @param {string} email - The email of the user to update.
   * @param {Object} preferences - The preferences to include in the user's data.
   * @returns {DAOResponse}
   */
  static async updatePreferences(email, preferences) {
    try {
      /**
      Ticket: User Preferences

      Update the "preferences" field in the corresponding user's document to
      reflect the new information in preferences.
      */

      preferences = preferences || {}

      // TODO Ticket: User Preferences
      // Use the data in "preferences" to update the user's preferences.
      const updateResponse = await users.updateOne(
        { email },
        { $set: { preferences } },
      )

      if (updateResponse.matchedCount === 0) {
        return { error: "No user found with that email" }
      }
      return updateResponse
    } catch (e) {
      console.error(
        `An error occurred while updating this user's preferences, ${e}`,
      )
      return { error: e }
    }
  }

  static async checkAdmin(email) {
    try {
      const { isAdmin } = await this.getUser(email)
      return isAdmin || false
    } catch (e) {
      return { error: e }
    }
  }

  static async makeAdmin(email) {
    try {
      const updateResponse = users.updateOne(
        { email },
        { $set: { isAdmin: true } },
      )
      return updateResponse
    } catch (e) {
      return { error: e }
    }
  }
}

/**
 * Parameter passed to addUser method
 * @typedef UserInfo
 * @property {string} name
 * @property {string} email
 * @property {string} password
 */

/**
 * Success/Error return object
 * @typedef DAOResponse
 * @property {boolean} [success] - Success
 * @property {string} [error] - Error
 */
