#!/bin/bash
#
# Example: Cron-based Elasticsearch Snapshot Verifier
#
# This script is meant to be called by cron to periodically verify a snapshot
# repository and expose Prometheus-compatible metrics for monitoring.
#
# Requirements:
# - A read-only API key file located at /etc/elasticsearch/readonly-api-key
# - Node Exporter's textfile collector enabled at /var/lib/node_exporter/textfile_collector/
# - Elasticsearch running locally or accessible via $ES_HOST
#
# Note: For production use, place this logic directly into a cron job or systemd timer.
#       This script is just an example for demonstration and testing.

# Fail fast on error
set -euo pipefail

# === Configuration ===
export REPO_NAME="my_backup_repo"
export ES_HOST="http://localhost:9200"
export API_KEY_FILE="/etc/elasticsearch/readonly-api-key"
export PROM_FILE="/var/lib/node_exporter/textfile_collector/es_snapshot_${REPO_NAME}.prom"

# === Invoke snapshot verification script ===
/opt/elasticsearch-tools/tools/snapshot-verifier/verify_snapshot.sh
