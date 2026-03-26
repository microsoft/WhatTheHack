import UsersDAO from "../src/dao/usersDAO"

const testUser = {
  name: "foo",
  email: "foobaz@bar.com",
  password: "foobar",
}

describe("User Preferences", () => {
  beforeAll(async () => {
    await UsersDAO.injectDB(global.mflixClient)
  })

  afterAll(async () => {
    await UsersDAO.deleteUser(testUser.email)
  })

  test("Invalid user should not have preferences", async () => {
    await UsersDAO.deleteUser(testUser.email)
    const preferences = {
      color: "green",
      favorite_letter: "q",
      favorite_number: 42,
    }

    const result = await UsersDAO.updatePreferences(testUser.email, preferences)
    const expected = { error: "No user found with that email" }

    expect(result).toEqual(expected)
  })

  test("Null preferences should be valid", async () => {
    await UsersDAO.addUser(testUser)
    const preferences = null
    await UsersDAO.updatePreferences(testUser.email, preferences)
    const userData = await UsersDAO.getUser(testUser.email)

    expect(userData.preferences).toEqual({})
  })

  test("Valid preferences are reflected in DB", async () => {
    await UsersDAO.addUser(testUser)

    // first set of preferences
    const preferences = {
      favorite_cast_member: "Goldie Hawn",
      favorite_genre: "Comedy",
      preferred_ratings: ["G", "PG", "PG-13"],
    }

    let updateResult = await UsersDAO.updatePreferences(
      testUser.email,
      preferences,
    )
    expect(updateResult.matchedCount).toBe(1)
    expect(updateResult.modifiedCount).toBe(1)

    const userData = UsersDAO.getUser(testUser.email)
    expect(userData.preferences).not.toBeNull()

    // second set of preferences
    const newPreferences = {
      favorite_cast_member: "Daniel Day-Lewis",
      favorite_genre: "Drama",
      preferred_ratings: ["R"],
    }

    updateResult = await UsersDAO.updatePreferences(
      testUser.email,
      newPreferences,
    )
    expect(updateResult.matchedCount).toBe(1)
    expect(updateResult.modifiedCount).toBe(1)

    const newUserData = await UsersDAO.getUser(testUser.email)
    expect(newUserData.preferences).toEqual(newPreferences)
  })
})
