require("dotenv").config()
const { MongoClient, ObjectId } = require("mongodb")

module.exports = async function() {
  console.log("Setup Mongo Connection")

  if (!process.env.MFLIX_DB_URI || !process.env.MFLIX_NS) {
    return
  }

  let client
  try {
    client = await MongoClient.connect(process.env.MFLIX_DB_URI, {
      maxPoolSize: 5,
      wtimeoutMS: 2500,
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })

    const db = client.db(process.env.MFLIX_NS)
    const movies = db.collection("movies")

    try {
      const indexes = await movies.indexes()
      const hasTextIndex = indexes.some(index =>
        Object.values(index.key || {}).includes("text"),
      )

      if (!hasTextIndex) {
        await movies.createIndex(
          { title: "text", fullplot: "text" },
          { name: "TextIndex", background: true },
        )
      }
    } catch (e) {
      console.warn(`Text index setup warning: ${e}`)
    }

    const migrationMovieId = new ObjectId("573a1391f29313caabcd7a34")
    const movie = await movies.findOne(
      { _id: migrationMovieId },
      { projection: { lastupdated: 1 } },
    )

    if (movie && typeof movie.lastupdated === "string") {
      try {
        const parsedDate = new Date(Date.parse(movie.lastupdated))
        if (!Number.isNaN(parsedDate.getTime())) {
          await movies.updateOne(
            { _id: migrationMovieId },
            { $set: { lastupdated: parsedDate } },
          )
        }
      } catch (e) {
        console.warn(`Migration setup warning: ${e}`)
      }
    }
  } catch (e) {
    console.warn(`Global test setup warning: ${e}`)
  } finally {
    if (client) {
      await client.close()
    }
  }
}
