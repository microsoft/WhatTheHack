require("dotenv").config()
const MongoClient = require("mongodb").MongoClient
const faker = require("faker")
const MIN_LOAN_AMOUNT = 500
const MAX_LOAN_AMOUNT = 100000
;(async function() {
  const client = await MongoClient.connect(process.env.MFLIX_DB_URI, {
    wtimeoutMS: 2500,
    maxPoolSize: 50,
    useNewUrlParser: true,
  })

  /**
    In this portion of the lesson, we'll cover `update` change events, as well
    as using a pipeline with the change stream.
  */

  try {
    const bankDB = await client.db("bankDB")
    const loans_collection = await bankDB.collection("loans")

    /**
      Using a pipeline with a $match stage allows us to reduce the noise in our
      change stream.

      In this example, our bank issues loans between 500 and 100000 USD. This is
      a wide range of values. We want to capture the highest-value loans, and
      send a message congratulating the broker.
    */

    // empty pipeline
    const emptyPipeline = []

    // pipeline with a filter on the loan size
    const highAmountPipeline = [
      { $match: { "fullDocument.amount": { $gt: 85000 } } },
    ]

    /**
      By default, "update" operations will NOT return a full document to the
      change stream. However, we can specify that we want the entire document
      with the flag `{ fullDocument: "updateLookup" }`.

      By using this field, we can use all the fields in the updated document.
      In this example, we used the "broker" field to print out a detailed
      message, even though we only updated the "amount" and "dueDate" fields.
    */

    // we can use { fullDocument: "updateLookup" } to return full documents to
    // the change stream after update operations
    const changeStream = loans_collection.watch(highAmountPipeline, {
      fullDocument: "updateLookup",
    })

    /**
      After filtering on loan amount, we can further specify the operation, by
      `operationType`. This field appears in the change event, and it can alert
      us to the nature of this operation.

      In this example, we consider events with "insert" to be new loans, and
      events with "update" to be existing loans that were refinanced. We use
      this distinction to provide a more detailed message.
    */

    changeStream.on("change", change => {
      // console.log(change)
      let { amount, broker, borrower } = change.fullDocument
      switch (change.operationType) {
        case "insert":
          console.log(
            `${broker} just negotiated a new loan with ${borrower} worth ${amount} USD!`,
          )
          break
        case "update":
          console.log(
            `${broker} just refinanced a loan with ${borrower} worth ${amount} USD!`,
          )
          break
      }
    })

    // update the loans in this collection, to simulate loans being created and
    // restructured/refinanced
    await simulateBankActivity(loans_collection)

    // close the change stream and drop loans_collection when we're done
    await changeStream.close()
    await loans_collection.drop()

    process.exit(1)
  } catch (e) {
    console.log(e)
  }

  async function simulateBankActivity(collection) {
    // produce a random integer - this will be each loan's amount
    function getRandomLoanAmount() {
      const min = Math.ceil(MIN_LOAN_AMOUNT)
      const max = Math.floor(MAX_LOAN_AMOUNT)
      return Math.floor(Math.random() * (max - min)) + min
    }

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

    // randomly insert/update loan documents with new amounts and due dates
    // alternates between inserting and updating data
    for (let i = 0; i < 1000; i++) {
      let newLoanData = {
        borrower: faker.name.findName(),
        broker: faker.name.findName(),
        amount: getRandomLoanAmount(),
        dueDate: getRandomDueDate(),
      }
      if (i < 50 || i % 2 == 0) {
        let insertResult = await collection.insertOne(newLoanData)
      } else {
        let { amount, broker, dueDate } = newLoanData

        // randomly select a loan in loans_collection
        // to update its amount and due date
        let updateResult = await collection.updateOne(
          { _id: { $exists: true } },
          {
            $set: { amount, dueDate },
          },
        )
      }
      await sleep(1000)
    }
  }
})()
