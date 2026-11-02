#!/bin/bash
# Load the three Precision Labs indices into your Elasticsearch Serverless project.
#
# Usage:
#   From the student resource root, copy .env.sample to .env and set
#   ELASTICSEARCH_URL and ELASTIC_API_KEY (the setup key), then run:
#   python3 -m pip install elasticsearch python-dotenv
#   bash data/load_data.sh
#
# Exported settings override .env. Legacy ES_URL / ES_API_KEY exports are supported
# and take precedence over ELASTICSEARCH_URL / ELASTIC_API_KEY.
#
# Deletes and recreates the three precision-* indices each run. Data is generated
# deterministically (seed 42), so every run produces the same documents. Takes under 90 s.
set -euo pipefail
cd "$(dirname "$0")"

PYTHON="${PYTHON:-python3}"

read_setting() {
  "$PYTHON" - "$1" "$2" <<'PY'
import os
import sys

try:
    from dotenv import load_dotenv
except ImportError:
    sys.exit("Missing python-dotenv. Install it with: python3 -m pip install python-dotenv")

load_dotenv("../.env", override=False)
name, legacy_name = sys.argv[1:]
value = (os.environ.get(legacy_name) or os.environ.get(name) or "").strip()
if not value:
    sys.exit(f"Set {name} in the student resource root's .env file, then rerun the loader.")
print(value)
PY
}

ES_URL="$(read_setting ELASTICSEARCH_URL ES_URL)"
ES_API_KEY="$(read_setting ELASTIC_API_KEY ES_API_KEY)"

echo "--- precision-crm-accounts (500 accounts) ---"
"$PYTHON" crm_dataset.py --es-url "$ES_URL" --api-key "$ES_API_KEY"

echo "--- precision-support-tickets (3000 tickets) ---"
PYTHONPATH=. "$PYTHON" support_tickets_dataset.py --es-url "$ES_URL" --api-key "$ES_API_KEY"

echo "--- precision-kb-articles (150 articles) ---"
"$PYTHON" kb_articles_dataset.py --es-url "$ES_URL" --api-key "$ES_API_KEY"

echo "=== Verifying counts ==="
for idx in precision-crm-accounts precision-support-tickets precision-kb-articles; do
  printf '  %s: ' "$idx"
  curl -sf -H "Authorization: ApiKey ${ES_API_KEY}" "${ES_URL}/${idx}/_count" \
    | "$PYTHON" -c "import sys,json; print(json.load(sys.stdin)['count'])" || echo "ERR"
done
