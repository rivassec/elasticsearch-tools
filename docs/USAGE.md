# Usage Guide

This repository provides standalone tools to enhance Elasticsearch operational security. Each tool is designed for minimal permissions, scriptability, and safe integration into CI/CD or production environments.

---

## 🧪 Snapshot Verifier

### Overview

`tools/snapshot-verifier/verify_snapshot.sh` is a secure, Prometheus-compatible Bash script to verify that a given snapshot repository is healthy and accessible. This tool requires only readonly permissions and avoids high-risk actions like deletion or modification.

---

### 🔧 Requirements

- Elasticsearch cluster (7.x or newer)
- An API key with the following cluster privileges:
  - `cluster:admin/repository/get`
  - `cluster:admin/repository/verify`
  - `cluster:admin/snapshot/get`
  - `cluster:admin/snapshot/status`
- Access to `jq`, `curl`, `bash`

---

### 🔐 API Key Setup

Create a scoped API key with the required permissions:

```bash
curl -u elastic:${ELASTICPASS} -X POST "localhost:9200/_security/api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "readonly-snapshot-verifier",
    "role_descriptors": {
      "snapshot_repo_readonly": {
        "cluster": [
          "cluster:admin/repository/get",
          "cluster:admin/repository/verify",
          "cluster:admin/snapshot/get",
          "cluster:admin/snapshot/status"
        ],
        "indices": [],
        "run_as": [],
        "metadata": {},
        "transient_metadata": {
          "enabled": true
        }
      }
    },
    "expiration": "30d"
  }'


