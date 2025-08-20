#!/usr/bin/env bash
set -euo pipefail

echo "=== System Info ==="
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Disk Usage:"
df -h
