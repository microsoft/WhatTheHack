#!/usr/bin/env bash
# Recreate indexes from Atlas source to Azure DocumentDB target.
# Replace <SRC_PASSWORD> and <TGT_PASSWORD> with URL-encoded credentials before running.

SRC_URI="mongodb+srv://perktime_db_user:<SRC_PASSWORD>@ac-oszotkx-shard-00-00.ouvmsr8.mongodb.net" \
SRC_DB='sample_mflix' \
TGT_URI="mongodb+srv://pete:<TGT_PASSWORD>@mflix.mongocluster.cosmos.azure.com" \
TGT_DB='sample_mflix' \
DRY_RUN='false' \
COSMOS_COMPAT='false' \
/usr/bin/mongosh --nodb --norc --file "$(dirname "$0")/recreate-indexes.mongosh.js"
