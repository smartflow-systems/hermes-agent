#!/usr/bin/env bash
# SFS-standard health probe for the hermes-agent gateway API server.
# Upstream serves GET /health on port 8642 (API_SERVER_PORT overrides).
set -euo pipefail

PORT="${PORT:-${API_SERVER_PORT:-8642}}"
HOST="${HOST:-localhost}"
URL="http://${HOST}:${PORT}/health"

BODY="$(curl -sf --max-time 5 "$URL")" || {
    echo "UNHEALTHY: no response from $URL (is the gateway running?)"
    exit 1
}

# Upstream shape is {"status":"ok",...}; also accept the SFS {"ok":true} shape.
if grep -qE '"status" *: *"ok"|"ok" *: *true' <<<"$BODY"; then
    echo "HEALTHY: $URL -> $BODY"
else
    echo "UNHEALTHY: $URL -> $BODY"
    exit 1
fi
