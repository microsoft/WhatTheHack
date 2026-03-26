const MongoClient = require("mongodb").MongoClient
const faker = require("faker")
require("dotenv").config()
;(async function() {
  const client = await MongoClient.connect(process.env.MFLIX_DB_URI, {
    wtimeoutMS: 2500,
    maxPoolSize: 50,
    useNewUrlParser: true,
  })

  /**
    In this lesson, we're going to use change streams to track real-time
    changes to the data that our application's using.

    We will open a change stream at the collection level. By default, the change
    stream will capture any change made to the collection, but we are going to
    start by focusing on inserts.
  */

  try {
    /**
      A change stream contains change events for different database operations
      that result in some change to the data. These could be inserts, updates or
      deletes.

      The fields available to us in each change event will vary depending on the
      operation, but operation type will always appear, along with clusterTime.
      Operation type tells us whether it was an insert, update or delete, and
      clusterTime tells us the time when the operation completed.

      The fullDocument field appears in insert change events, and it gives us
      the entire document that was just inserted. We can also return this to the
      change stream cursor for update operations, we just have to ask for it
      specifically - we'll cover that in a bit.

      The updateDescription field only appears in update operations, and it
      tells us which fields were updated and which fields were removed from the
      existing document.
    */

    const bankDB = await client.db("bankDB")
    const loans_collection = await bankDB.collection("loans")

    /**
      To open a change stream against a specific collection, we call the
      collection method .watch(). This method takes an optional pipeline
      parameter, which we can use to transform or filter out change events.

      Opening a change stream opens the flow of change events to the change
      stream cursor. From the application side, we pull change events from this
      change stream cursor.

      When we pass an empty pipeline, every data change will result in a change
      event document in our cursor.
    */

    const emptyPipeline = []
    const changeStream = loans_collection.watch(emptyPipeline)

    /**
      Using .on(), we can tell the change stream to do something for each change
      event in the cursor.

      In this example, we've asked the change stream to log each change to the
      console. We could also write those changes to a file, or maybe send an
      email alert.
    */

    changeStream.on("change", change => {
      console.log("change", change)
    })

    /**
      In addition to "change", .on() also takes the following event types:
      "close", "end", and "error". We can use these event types to alert us
      for different reasons.
    */

    // populate loans_collection with data
    await insertDocs(loans_collection)

    // close the change stream when we're done
    changeStream.close()

    // drop loans_collection
    loans_collection.drop()

    // exit the program
    process.exit(1)
  } catch (e) {
    console.log(e)
  }

  /**
    In this example, the namespace bankDB.loans stores a document for each loan
    issued by the bank. Our change stream is going to track every change made to
    this collection.
   */

  // insert documents into `bankDB.loans`
  async function insertDocs(collection) {
    let amounts = [2000, 400, 5000, 1200, 350, 10000, 3500, 800]
    let borrowerNames = [
      "Manjunath",
      "Hamsa",
      "Gayatri",
      "Tanvi",
      "Aditya",
      "Akash",
      "Arjun",
      "Divya",
    ]

    // get a random date - this will be each loan's due date
    function getRandomDueDate() {
      let startDate = new Date()
      let endDate = new Date(2030, 0, 1)
      return new Date(
        startDate.getTime() +
          Math.random() * (endDate.getTime() - startDate.getTime()),
      )
    }

    // sleep for a given number of ms
    async function sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms))
    }

    // use .map() to create the loan documents
    let docs = amounts.map((amount, idx) => ({
      amount,
      borrower: borrowerNames[idx],
      dueDate: getRandomDueDate(),
    }))

    // insert the loan documents
    for (var idx = 0; idx < docs.length; idx++) {
      let doc = docs[idx]
      let insertResult = collection.insertOne(doc)
      await sleep(1000)
    }
  }

  /**
    Now that we've opened a change stream on the "loans" collection, we should
    see any new loans that come in, as well as any changes made to existing
    loans.

    On the output, we can see that each change event has an "operationType". In
    this example, they all have type "insert".

    We also have a "fullDocument" field, which has the entire document after the
    change event occurred. In this example, the change events are inserts, so
    the _id in the full document was just created by MongoDB.

    However, we still haven't pased a pipeline to the change stream. Because of
    this, the change stream cursor will capture any change, regardless of
    context. We might want to specify which changes we actually care about.
  */
})()
