import app from "./server"
import { MongoClient } from "mongodb"
import MoviesDAO from "../src/dao/moviesDAO"
import UsersDAO from "./dao/usersDAO"
import CommentsDAO from "./dao/commentsDAO"

const port = process.env.PORT || 5001

/**
Ticket: Connection Pooling

Please change the configuration of the MongoClient object by setting the
maximum connection pool size to 50 active connections.
*/

/**
Ticket: Timeouts

Please prevent the program from waiting indefinitely by setting the write
concern timeout limit to 2500 milliseconds.
*/

// const MongoClient = require('mongodb').MongoClient;
const uri = process.env.MFLIX_DB_URI
// const client = new MongoClient(uri, { useNewUrlParser: true })
// client.connect(err => {
//   const collection = client.db("test").collection("devices")
//   // perform actions on the collection object
//   client.close()
// })

MongoClient.connect(
  uri,
  // TODO: Connection Pooling
  // Set the poolSize to 50 connections.
  // TODO: Timeouts
  // Set the write timeout limit to 2500 milliseconds.
  {
    maxPoolSize: 50,
    wtimeoutMS: 2500,
  },
)
  .catch(err => {
    console.error(err.stack)
    process.exit(1)
  })
  .then(async client => {
    await MoviesDAO.injectDB(client)
    await UsersDAO.injectDB(client)
    await CommentsDAO.injectDB(client)
    app.listen(port, () => {
      console.log(`listening on port ${port}`)
    })
  })
