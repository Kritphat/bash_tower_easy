#!/bin/bash
# Gives one player a fresh tower with the same passwords.
#   ./reset.sh player07
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! "${1:-}" =~ ^(player[0-9]{2}|teacher[0-9]{2}|testuser)$ ]]; then
    echo "usage: $0 playerNN | teacherNN | testuser" >&2
    exit 1
fi

docker compose up -d --build --force-recreate "$1"
