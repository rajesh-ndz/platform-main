#!/bin/bash
set -euxo pipefail

# Detect OS
if [ -f /etc/os-release ]; then . /etc/os-release; fi

# Ubuntu usually has snap; prefer snap flow first
if command -v snap >/dev/null 2>&1; then
  snap start amazon-ssm-agent || {
    (apt-get update -y || true)
    (apt-get install -y snapd || true)
    snap install amazon-ssm-agent --classic || true
    snap start amazon-ssm-agent || true
  }
  systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service || true
else
  # Amazon Linux / RHEL / Debian fallback installers
  (dnf install -y amazon-ssm-agent || yum install -y amazon-ssm-agent || (apt-get update -y && apt-get install -y amazon-ssm-agent)) || true
  systemctl enable --now amazon-ssm-agent || true
fi
EOF
