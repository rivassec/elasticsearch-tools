This directory contains automation scripts designed to interact securely with Elasticsearch using minimal permissions.

## Included Scripts

### verify_snapshot.sh

This script performs verification of an Elasticsearch snapshot repository and exports Prometheus-compatible metrics. It is useful in environments where external monitoring agents such as Datadog or Prometheus exporters are not allowed or are impractical.

Key features:
- Uses an API key with a restricted role
- Outputs metrics in Prometheus textfile format
- Validates input and enforces safe file handling
- Designed for production environments and minimal attack surface

See `../docs/USAGE.md` for integration and deployment instructions.

## Security Considerations

All scripts in this directory follow these principles:
- Principle of least privilege
- No destructive actions
- Secure handling of sensitive data
- Suitable for automation and air-gapped usage

## How to Use

Ensure your API key is stored securely, such as in `/etc/elasticsearch/readonly-api-key`, and has file permissions set to `0600`. Scripts can be executed via cron, systemd timers, or Kubernetes CronJobs depending on your environment.

If additional scripts are added in the future, follow the same conventions and document them here.
