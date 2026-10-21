#!/bin/bash
# Builds and starts the tower of every player. Safe to run again.
set -euo pipefail
cd "$(dirname "$0")"

docker build -t locstd-easy-base -f base/dockerfile base
docker compose up -d --build
docker compose ps
