#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r backend/requirements.txt
if [[ ! -f .env ]]; then cp .env.example .env; fi
(cd frontend && npm install)

echo "Setup complete. Start the backend with: .venv/bin/python -m uvicorn backend.app.main:app --host 0.0.0.0 --port 8000"
echo "Start the frontend in another terminal with: cd frontend && npm run dev -- --host 0.0.0.0 --port 5173"
