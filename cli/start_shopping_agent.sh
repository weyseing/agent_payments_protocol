# !/bin/bash
uv run --no-sync --env-file .env --package ap2-samples adk web --host 0.0.0.0 "samples/python/src/roles" --reload_agents
