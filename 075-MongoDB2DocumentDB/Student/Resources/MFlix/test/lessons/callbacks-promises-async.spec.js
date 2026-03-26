describe("Callbacks, Promises, and Aysnc/Await", () => {
  /**
   * In this lesson, we'll discuss the difference between callbacks, promises,
   * and async/await in modern Javascript. We'll also discuss how the Node
   * driver responds depending on how you call certain methods.
   */
  let movies
  beforeAll(async () => {
    movies = await global.mflixClient
      .db(process.env.MFLIX_NS)
      .collection("movies")
  })

  test("Callbacks", done => {
    /**
     * Unless you are completely new to Javascript - and welcome if you are! -
     * you are most likely familiar with callbacks. For those that might need
     * a refresher, callbacks are a way of passing a bundle of information along
     * to a different part of our program. They are functions that some other
     * portion of code can run. I like to think of them like handing a remote
     * control to someone else. Let's look at an example.
     *
     * For each example, we'll print out the collection names we have.
     */
    movies.findOne({ title: "Once Upon a Time in Mexico" }, function(err, doc) {
      expect(err).toBeNull()
      expect(doc.title).toBe("Once Upon a Time in Mexico")
      expect(doc.cast).toContain("Salma Hayek")
      done()
    })
    /**
     * Here we passed a callback function. If there would have been an error,
     * the `err` paramater would have been some other value than Null. The doc
     * parameter was the found document.
     */
  })

  test("Promises", done => {
    /**
     * Now we'll jump into Promises. Promises are a way of saying "Do this
     * thing and when it's done do one of two things: Resolve or Reject".
     * Promises allow us to be more declarative. Let's look at the same query
     * as before but instead use a Promise.
     *
     * One interesting note. While browsing the Node driver documentation you
     * may encounter documentation like the following:
     *
     * findOne(query, options, callback) -> {Promise}
     *
     * The Driver team inspects whether a callback is passed. If none is, the
     * driver will return a Promise automatically. Great stuff!
     */

    movies
      .findOne({ title: "Once Upon a Time in Mexico" })
      .then(doc => {
        expect(doc.title).toBe("Once Upon a Time in Mexico")
        expect(doc.cast).toContain("Salma Hayek")
        done()
      })
      .catch(err => {
        expect(err).toBeNull()
        done()
      })

    /**
     * This is pretty nice. We said "Hey Mongo, find one document where the
     * title is 'Once Upon a Time in Mexico', THEN I'll do something with that.
     * CATCH any error and let me do something with that"
     *
     * Now on to async/await!
     */
  })

  test("Async/Await", async () => {
    /**
     * There's another way to handle Promises that results in very clean code,
     * and that's using async/await. It's the style we use throughout the
     * codebase for this project!
     *
     * Don't let the terminology intimidate you. We Javascript programmers like
     * to add fancy names to things to feel better about things like
     * ![] evaluating to false. Forgive us.
     *
     * To use async/await, we need to mark our function as async, as can be seen
     * in the test function for this portion of the lesson. This then let's us
     * use the `await` keyword for Promises. Behind the scenes, you can think
     * of it as attaching the `.then()` part to a promise and returning that
     * value.
     *
     * What about the `.catch()` part? That's handled by a catch block. An
     * important thing to remember is to always surround `await` statements with
     * a try/catch block.
     *
     * Let's see an example.
     */

    try {
      let { title } = await movies.findOne({
        title: "Once Upon a Time in Mexico",
      })
      let { cast } = await movies.findOne({
        title: "Once Upon a Time in Mexico",
      })
      expect(title).toBe("Once Upon a Time in Mexico")
      expect(cast).toContain("Salma Hayek")
    } catch (e) {
      expect(e).toBeNull()
    }

    /**
     * I've used destructuring here to lift the title and cast keys from the
     * returned document. It would have been more efficient to do a single
     * findOne operation and grab the title and cast at the same time, but I
     * wanted to demonstrate that multiple awaits can be within the same
     * try/catch block.
     */
  })

  /**
   * And that covers Callbacks, Promises, and Async/Await at a high level and
   * how the Node driver will behave when passed a callback or not. If any of
   * this is unclear, don't worry. Head to our forums to ask for help. If you
   * are very new to Javascript and aren't familiar with callbacks or promises,
   * I recommend reading
   * https://medium.com/front-end-hacking/callbacks-promises-and-async-await-ad4756e01d90
   *
   * Some things to remember.
   * You should always wrap await statements with a try/catch block.
   * If you aren't comfortable with Promises, you can supply a callback to the
   * Node driver methods that are asynchronous.
   * If you don't pass a callback, a Promise will be returned.
   *
   */
})
