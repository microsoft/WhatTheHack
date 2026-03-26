import UsersDAO from "../src/dao/usersDAO"
const testUser = {
  name: "Magical Mr. Mistoffelees",
  email: "magicz@cats.com",
  password: "somehashedpw",
}

const sessionUser = {
  user_id: testUser.email,
  jwt: "hello",
}

describe("User Management", () => {
  beforeAll(async () => {
    await UsersDAO.injectDB(global.mflixClient)
  })

  afterAll(async () => {
    await UsersDAO.deleteUser(testUser.email)
  })

  test("it can add a new user to the database", async () => {
    /**
     * The password WILL be hashed at the API layer prior to sending it to the
     * UsersDAO object.
     * NEVER
     * NEVER
     * NEVER store plaintext passwords, PLEASE
     */
    const actual = await UsersDAO.addUser(testUser)
    expect(actual.success).toBeTruthy()
    expect(actual.error).toBeUndefined()

    // we should be able to get the user
    const user = await UsersDAO.getUser(testUser.email)
    // for comparison, we delete the _id key returned from Mongo
    delete user._id
    expect(user).toEqual(testUser)
  })

  test("it returns an error when trying to register duplicate user", async () => {
    const expected = "A user with the given email already exists."
    const actual = await UsersDAO.addUser(testUser)
    expect(actual.error).toBe(expected)
    expect(actual.success).toBeFalsy()
  })

  test("it allows a user to login", async () => {
    const actual = await UsersDAO.loginUser(testUser.email, sessionUser.jwt)
    expect(actual.success).toBeTruthy()
    const sessionResult = await UsersDAO.getUserSession(testUser.email)
    delete sessionResult._id
    expect(sessionResult).toEqual(sessionUser)
  })

  test("it allows a user to logout", async () => {
    const actual = await UsersDAO.logoutUser(testUser.email)
    expect(actual.success).toBeTruthy()
    const sessionResult = await UsersDAO.getUserSession(testUser.email)
    expect(sessionResult).toBeNull()
  })
})
