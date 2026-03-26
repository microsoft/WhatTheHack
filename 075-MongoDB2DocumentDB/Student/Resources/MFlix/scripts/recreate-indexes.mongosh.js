/*
  Recreate indexes from a source MongoDB database into a target database.

  Usage (example):
    SRC_URI='mongodb+srv://user:pass@source' \
    SRC_DB='sample_mflix' \
    TGT_URI='mongodb://user:pass@target' \
    TGT_DB='sample_mflix' \
    DRY_RUN='true' \
    COSMOS_COMPAT='true' \
    mongosh --norc --file scripts/recreate-indexes.mongosh.js

  Optional env vars:
    INCLUDE_COLLECTIONS='movies,comments'   // default: all
    EXCLUDE_COLLECTIONS='sessions'          // default: none
    DROP_CONFLICTING='false'                // drop index by name if definition differs
    RUN_UNIQUE_LAST='true'                  // create unique indexes after non-unique
*/

function env(name, fallback = "") {
  if (typeof process === "undefined" || !process.env) return fallback
  const value = process.env[name]
  return value === undefined || value === null || value === ""
    ? fallback
    : value
}

function toBool(value, fallback = false) {
  if (value === undefined || value === null || value === "") return fallback
  const normalized = String(value)
    .toLowerCase()
    .trim()
  return ["1", "true", "yes", "y", "on"].includes(normalized)
}

function csvToSet(value) {
  if (!value) return new Set()
  return new Set(
    value
      .split(",")
      .map(v => v.trim())
      .filter(Boolean),
  )
}

function isTextIndexKey(keySpec) {
  return Object.values(keySpec || {}).some(v => v === "text")
}

function isWildcardIndexKey(keySpec) {
  return Object.keys(keySpec || {}).some(k => k.includes("$**"))
}

function sanitizeOptions(indexDoc, cosmosCompat) {
  const allowed = [
    "name",
    "unique",
    "sparse",
    "expireAfterSeconds",
    "partialFilterExpression",
    "collation",
    "weights",
    "default_language",
    "language_override",
  ]

  const opts = {}
  allowed.forEach(field => {
    if (Object.prototype.hasOwnProperty.call(indexDoc, field)) {
      opts[field] = indexDoc[field]
    }
  })

  if (cosmosCompat) {
    delete opts.collation
    delete opts.partialFilterExpression
    delete opts.weights
    delete opts.default_language
    delete opts.language_override
  }

  return opts
}

function stableStringify(value) {
  if (value === null || typeof value !== "object") return JSON.stringify(value)
  if (Array.isArray(value)) {
    return `[${value.map(item => stableStringify(item)).join(",")}]`
  }
  const keys = Object.keys(value).sort()
  return `{${keys
    .map(key => `${JSON.stringify(key)}:${stableStringify(value[key])}`)
    .join(",")}}`
}

function sameIndexDefinition(existing, key, options) {
  const existingKey = existing.key || {}
  const existingOptions = sanitizeOptions(existing, false)

  const currentNormalized = stableStringify({
    key: existingKey,
    options: existingOptions,
  })
  const wantedNormalized = stableStringify({ key, options })

  return currentNormalized === wantedNormalized
}

function main() {
  const srcUri = env("SRC_URI")
  const srcDbName = env("SRC_DB")
  const tgtUri = env("TGT_URI")
  const tgtDbName = env("TGT_DB")

  if (!srcUri || !srcDbName || !tgtUri || !tgtDbName) {
    throw new Error(
      "Missing required env vars. Required: SRC_URI, SRC_DB, TGT_URI, TGT_DB",
    )
  }

  const dryRun = toBool(env("DRY_RUN", "true"), true)
  const cosmosCompat = toBool(env("COSMOS_COMPAT", "true"), true)
  const dropConflicting = toBool(env("DROP_CONFLICTING", "false"), false)
  const runUniqueLast = toBool(env("RUN_UNIQUE_LAST", "true"), true)

  const includeCollections = csvToSet(env("INCLUDE_COLLECTIONS"))
  const excludeCollections = csvToSet(env("EXCLUDE_COLLECTIONS"))

  const source = new Mongo(srcUri).getDB(srcDbName)
  const target = new Mongo(tgtUri).getDB(tgtDbName)

  let collections = source
    .getCollectionNames()
    .filter(name => !name.startsWith("system."))

  if (includeCollections.size > 0) {
    collections = collections.filter(name => includeCollections.has(name))
  }

  if (excludeCollections.size > 0) {
    collections = collections.filter(name => !excludeCollections.has(name))
  }

  print(`Source DB: ${srcDbName}`)
  print(`Target DB: ${tgtDbName}`)
  print(`Collections: ${collections.join(", ") || "(none)"}`)
  print(
    `DRY_RUN=${dryRun}, COSMOS_COMPAT=${cosmosCompat}, RUN_UNIQUE_LAST=${runUniqueLast}`,
  )

  const tasks = []
  const skipped = []

  for (const collName of collections) {
    const sourceIndexes = source.getCollection(collName).getIndexes()

    for (const idx of sourceIndexes) {
      if (idx.name === "_id_") continue

      if (cosmosCompat && isTextIndexKey(idx.key)) {
        skipped.push({
          collection: collName,
          index: idx.name,
          reason: "text index skipped in COSMOS_COMPAT mode",
        })
        continue
      }

      if (cosmosCompat && isWildcardIndexKey(idx.key)) {
        skipped.push({
          collection: collName,
          index: idx.name,
          reason: "wildcard index skipped in COSMOS_COMPAT mode",
        })
        continue
      }

      tasks.push({
        collection: collName,
        key: idx.key,
        options: sanitizeOptions(idx, cosmosCompat),
      })
    }
  }

  if (runUniqueLast) {
    tasks.sort((a, b) => {
      const aUnique = !!a.options.unique
      const bUnique = !!b.options.unique
      if (aUnique === bUnique) return 0
      return aUnique ? 1 : -1
    })
  }

  let created = 0
  let skippedExisting = 0
  let dropped = 0
  let failed = 0

  for (const task of tasks) {
    const coll = target.getCollection(task.collection)
    const existingList = coll.getIndexes()
    const existing = existingList.find(i => i.name === task.options.name)

    if (existing && sameIndexDefinition(existing, task.key, task.options)) {
      skippedExisting += 1
      print(`[SKIP] ${task.collection}.${task.options.name} (already matches)`)
      continue
    }

    if (existing && !sameIndexDefinition(existing, task.key, task.options)) {
      if (!dropConflicting) {
        failed += 1
        print(
          `[FAIL] ${task.collection}.${task.options.name} exists with different definition. Set DROP_CONFLICTING=true to replace.`,
        )
        continue
      }

      if (dryRun) {
        print(`[DRY-RUN] dropIndex ${task.collection}.${task.options.name}`)
      } else {
        coll.dropIndex(task.options.name)
      }
      dropped += 1
    }

    if (dryRun) {
      print(
        `[DRY-RUN] createIndex ${task.collection} key=${JSON.stringify(
          task.key,
        )} options=${JSON.stringify(task.options)}`,
      )
      continue
    }

    try {
      coll.createIndex(task.key, task.options)
      created += 1
      print(`[OK] createIndex ${task.collection}.${task.options.name}`)
    } catch (err) {
      failed += 1
      print(
        `[FAIL] createIndex ${task.collection}.${task.options.name} -> ${err.message}`,
      )
    }
  }

  print("\n===== SUMMARY =====")
  print(`Indexes considered: ${tasks.length}`)
  print(`Created: ${created}`)
  print(`Skipped existing: ${skippedExisting}`)
  print(`Dropped conflicting: ${dropped}`)
  print(`Failed: ${failed}`)
  print(`Skipped by compatibility filter: ${skipped.length}`)

  if (skipped.length > 0) {
    print("\nSkipped indexes:")
    skipped.forEach(item => {
      print(`- ${item.collection}.${item.index}: ${item.reason}`)
    })
  }

  if (dryRun) {
    print("\nDRY_RUN is enabled. Set DRY_RUN=false to apply changes.")
  }
}

main()
