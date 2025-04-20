# Elasticsearch Tools

A growing collection of security-focused utilities for managing and monitoring Elasticsearch environments. Built with DevSecOps principles in mind, these tools prioritize least-privilege access, auditability, and operational safety.

## 🧰 What's Included

### 📦 [`snapshot-verifier`](tools/snapshot-verifier/)

A hardened Bash script that verifies snapshot repositories with minimal Elasticsearch privileges. Emits Prometheus-compatible metrics for monitoring snapshot health without exposing sensitive actions like deletion or repository modification.

- Requires only `cluster:admin/repository/verify` and related readonly privileges
- Safe for use in restricted environments or CI/CD pipelines
- Integrates easily with Prometheus Node Exporter or systemd timers

## 🔐 Security Principles

- No default use of `manage_snapshot` or other broad permissions
- API keys limited to explicit role descriptors
- Safe handling of credentials (via file-based access and permission checks)
- Optional integration with metrics pipelines without external agents

## 📄 License

[MIT License](LICENSE)

## 🤝 Contributions

Pull requests are welcome! If you have additional Elasticsearch operational tools or want to improve script portability, feel free to open an issue or submit a PR.

## 🗂️ Roadmap

Planned utilities may include:

- Snapshot expiration reporters
- Automated backup validation dashboards
- Snapshot repository diff/consistency checks
- Alerting hooks for verification failures
