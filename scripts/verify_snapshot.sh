#!/bin/bash

########################################################################
# Hardened Snapshot Monitor for Elasticsearch
# Purpose: Verify an Elasticsearch snapshot repository and expose
# Prometheus-style metrics securely.
########################################################################

set -euo pipefail

: "${ES_HOST:="http://localhost:9200"}"
: "${REPO_NAME:?Missing REPO_NAME}"
: "${API_KEY_FILE:="/etc/elasticsearch/readonly-api-key"}"
: "${PROM_FILE:="/var/lib/node_exporter/textfile_collector/es_snapshot.prom"}"

if [[ ! -f "$API_KEY_FILE" ]]; then
  echo "[FATAL] API key file not found: $API_KEY_FILE" >&2
  exit 2
fi

if [[ $(stat -c "%a" "$API_KEY_FILE") -gt 600 ]]; then
  echo "[FATAL] API key file permissions too permissive (should be 600 or less)" >&2
  exit 3
fi

API_KEY=$(<"$API_KEY_FILE")
TMP_PROM_FILE=$(mktemp)
safe_repo=safe_repo="${REPO_NAME//[^a-zA-Z0-9_]/_}"
timestamp=$(date +%s)

response=$(curl -fsSL --retry 3 --retry-delay 2 \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -X POST "$ES_HOST/_snapshot/$REPO_NAME/_verify" || true)

if jq -e '.nodes | length > 0' <<<"$response" >/dev/null 2>&1; then
  result=1
  status="ok"
else
  result=0
  status="failed"
fi

{
  echo "# HELP es_snapshot_repository_verified Success status of snapshot verification"
  echo "# TYPE es_snapshot_repository_verified gauge"
  echo "es_snapshot_repository_verified{repo=\"$safe_repo\"} $result"
  echo "# HELP es_snapshot_repository_verified_at Unix timestamp of last check"
  echo "# TYPE es_snapshot_repository_verified_at gauge"
  echo "es_snapshot_repository_verified_at{repo=\"$safe_repo\"} $timestamp"
} > "$TMP_PROM_FILE"

mv "$TMP_PROM_FILE" "$PROM_FILE"
logger -t es-snapshot-monitor "[INFO] Verification $status for '$REPO_NAME' (code=$result)"

exit 0
