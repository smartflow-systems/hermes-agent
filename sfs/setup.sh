#!/usr/bin/env bash
# SFS one-shot setup for hermes-agent.
# Wraps upstream setup-hermes.sh, then verifies the install.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

GOLD='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GOLD}== SFS setup: hermes-agent ==${NC}"

# 1. Upstream setup (venv, deps, CLI symlink). Pipe "n" to decline the
#    interactive wizard prompt at the end; run `hermes setup` manually after.
./setup-hermes.sh <<< "n"

# 2. .env from template
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GOLD}Created .env from template — add your OPENROUTER_API_KEY${NC}"
fi

# 3. Smoke check: core modules import inside the venv
if venv/bin/python -c "import hermes_constants, hermes_time, utils" 2>/dev/null; then
    echo -e "${GREEN}VERIFY OK: core modules import${NC}"
else
    echo -e "${RED}VERIFY FAILED: core imports broken — re-run ./setup-hermes.sh${NC}"
    exit 1
fi

echo -e "${GREEN}Done.${NC} Next: edit .env, then run 'hermes setup' or 'hermes'."
echo "UNDO: rm -rf venv .env  (removes venv and env file only)"
