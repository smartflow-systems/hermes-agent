# SFS Setup — hermes-agent

SmartFlow Systems integration for the `smartflow-systems/hermes-agent` fork.

Everything SFS-specific lives in this directory (plus
`.github/workflows/sfs-ci.yml`) so upstream syncs from
`NousResearch/Hermes-Agent` never conflict with it.

## Role in the SFS ecosystem

Hermes Agent is the **ops copilot runtime** for SFS: a self-hosted AI agent
with tool-calling, skills, cron jobs, and a gateway API. It is infrastructure,
not a sales product — Barber-booker-v1 and SocialScaleBooster remain the
revenue priorities.

## Quick start

```bash
./sfs/setup.sh        # venv + deps + .env + smoke check
./sfs/health-check.sh # probe the gateway health endpoint
```

## Setup details

`sfs/setup.sh` wraps the upstream `setup-hermes.sh` (uv-based, Python 3.11)
and then verifies the install with an import smoke check. After it runs:

1. Copy `.env.example` → `.env` (done automatically if missing).
2. Fill in your LLM provider key — `OPENROUTER_API_KEY` is the simplest
   single-key option.
3. Run `hermes setup` for the interactive wizard, or `hermes` to start.

## Health check (SFS standard)

All SFS apps expose a health endpoint. In this repo it is served by the
gateway API server:

| | |
|---|---|
| Endpoint | `GET /health` |
| Default port | `8642` (override with `API_SERVER_PORT`) |
| Response | `{"status": "ok", "platform": "hermes-agent"}` |
| Detailed | `GET /health/detailed` — uptime, connected platforms, PID |

Note: the response shape is upstream's (`{"status":"ok"}`), not the SFS
`{"ok":true}` shape. We deliberately do **not** patch upstream gateway code —
`sfs/health-check.sh` accepts the upstream shape instead.

```bash
./sfs/health-check.sh              # probes localhost:8642
PORT=5000 ./sfs/health-check.sh    # custom port
```

## CI

`.github/workflows/sfs-ci.yml` is a fast smoke lane (checkout → uv →
core install → import check → script lint). The heavy upstream test matrix
in `tests.yml` remains the real gate; the SFS lane exists so ecosystem
tooling has a consistent `SFS CI` status check across all smartflow-systems
repos. It needs **no secrets** to pass.

## Secrets (org standard)

Not required for CI here, but standard across smartflow-systems repos:

```bash
gh secret set SFS_PAT --body "$SFS_PAT"
gh secret set REPLIT_TOKEN --body "$REPLIT_TOKEN"
gh secret set SFS_SYNC_URL --body "$SFS_SYNC_URL"
```

## Brand

```
Black #0D0D0D · Brown #3B2F2F · Gold #FFD700 · Beige #F5F5DC
Font: Inter (sans), JetBrains Mono (mono)
```
