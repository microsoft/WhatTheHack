const MongoClient = require("mongodb").MongoClient
const mongodb = require("mongodb")
const NodeEnvironment = require("jest-environment-node")

function applyLegacyMongoCompat() {
  if (global.__mflixLegacyMongoCompatApplied) {
    return
  }

  global.__mflixLegacyMongoCompatApplied = true

  const { Collection, MongoServerError } = mongodb

  const originalInsertOne = Collection.prototype.insertOne
  Collection.prototype.insertOne = async function(...args) {
    const result = await originalInsertOne.apply(this, args)
    return {
      ...result,
      insertedCount: result.insertedCount || 1,
      result: result.result || { n: result.insertedCount || 1, ok: 1 },
    }
  }

  const originalUpdateOne = Collection.prototype.updateOne
  Collection.prototype.updateOne = async function(...args) {
    const result = await originalUpdateOne.apply(this, args)
    const upserted = result.upsertedId
      ? [{ index: 0, _id: result.upsertedId }]
      : []
    return {
      ...result,
      result: {
        n: result.matchedCount,
        nModified: result.modifiedCount,
        ok: 1,
        upserted,
      },
    }
  }

  const originalDeleteOne = Collection.prototype.deleteOne
  Collection.prototype.deleteOne = async function(...args) {
    const result = await originalDeleteOne.apply(this, args)
    return {
      ...result,
      result: { n: result.deletedCount, ok: 1 },
    }
  }

  const originalDeleteMany = Collection.prototype.deleteMany
  Collection.prototype.deleteMany = async function(...args) {
    const result = await originalDeleteMany.apply(this, args)
    return {
      ...result,
      result: { n: result.deletedCount, ok: 1 },
    }
  }

  const originalFindOne = Collection.prototype.findOne
  Collection.prototype.findOne = function(filter, options, callback) {
    if (typeof options === "function") {
      const cb = options
      return originalFindOne
        .call(this, filter)
        .then(doc => cb(null, doc))
        .catch(err => cb(err, null))
    }

    if (typeof callback === "function") {
      return originalFindOne
        .call(this, filter, options)
        .then(doc => callback(null, doc))
        .catch(err => callback(err, null))
    }

    return originalFindOne.call(this, filter, options)
  }

  if (
    MongoServerError &&
    !Object.getOwnPropertyDescriptor(MongoServerError.prototype, "errmsg")
  ) {
    Object.defineProperty(MongoServerError.prototype, "errmsg", {
      configurable: true,
      enumerable: false,
      get() {
        if (
          this.code === 11000 ||
          String(this.message)
            .toLowerCase()
            .includes("duplicate key")
        ) {
          return `E11000 duplicate key error collection: ${this.message}`
        }
        return this.message
      },
    })
  }

  const originalCountDocuments = Collection.prototype.countDocuments
  Collection.prototype.count = function(query = {}, options = {}) {
    return originalCountDocuments.call(this, query, options)
  }
}

module.exports = class MongoEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup()
    applyLegacyMongoCompat()

    if (!process.env.MFLIX_DB_URI) {
      throw new Error(
        "Missing MFLIX_DB_URI. Set it in your environment or .env before running tests.",
      )
    }

    if (!this.global.mflixClient) {
      this.global.mflixClient = await MongoClient.connect(
        process.env.MFLIX_DB_URI,
        // TODO: Connection Pooling
        // Set the connection pool size to 50 for the testing environment.
        {
          maxPoolSize: 50,
          // TODO: Timeouts
          // Set the write timeout limit to 2500 milliseconds for the testing environment.
          wtimeoutMS: 2500,
          useNewUrlParser: true,
          useUnifiedTopology: true,
        },
      )
    }
  }

  async teardown() {
    if (this.global.mflixClient) {
      await this.global.mflixClient.close()
    }
    await super.teardown()
  }

  runScript(script) {
    return super.runScript(script)
  }
}
