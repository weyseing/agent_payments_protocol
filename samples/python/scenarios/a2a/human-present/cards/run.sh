#!/bin/bash
set -e

# paths
AGENTS_DIR="samples/python/src/roles"
LOG_DIR=".logs"

# checking agent path
if [ ! -d "$AGENTS_DIR" ]; then
  echo "Error: Directory '$AGENTS_DIR' not found."
  echo "Please run this script from the root of the repository."
  exit 1
fi

# env
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# check google api key
USE_VERTEXAI=$(printf "%s" "${GOOGLE_GENAI_USE_VERTEXAI}" | tr '[:upper:]' '[:lower:]')
if [ -z "${GOOGLE_API_KEY}" ] && [ "${USE_VERTEXAI}" != "true" ]; then
  echo "Please set your GOOGLE_API_KEY environment variable before running."
  echo "Alternatively, set GOOGLE_GENAI_USE_VERTEXAI=true to use Vertex AI with ADC."
  exit 1
fi

# activate venv
echo "Setting up the Python virtual environment..."
if [ ! -d ".venv" ]; then
  uv venv
fi
source .venv/bin/activate
echo "Virtual environment activated."

# uv install (root package)
echo "Installing project in editable mode..."
uv pip install -e .

# create logs directory
mkdir -p "$LOG_DIR"

# kill process when ends
cleanup() {
  echo ""
  echo "Shutting down background processes..."
  if [ ${#pids[@]} -ne 0 ]; then
    kill "${pids[@]}" 2>/dev/null
    wait "${pids[@]}" 2>/dev/null
  fi
  echo "Cleanup complete."
}
trap cleanup EXIT

# uv sync (ap2-samples package)
echo "Syncing virtual environment with uv sync..."
if uv sync --package ap2-samples; then
  echo "Virtual environment synced successfully."
else
  echo "Error: uv sync failed. Aborting deployment."
  exit 1
fi

# clear old logs
echo "Clearing the logs directory..."
if [ -d "$LOG_DIR" ]; then
  rm -f "$LOG_DIR"/*
fi

pids=()
echo ""
echo "Starting remote servers and agents as background processes..."

# uv run
UV_RUN_CMD="uv run --no-sync"
if [ -f ".env" ]; then
  UV_RUN_CMD="$UV_RUN_CMD --env-file .env"
fi

# start merchant agent
echo "-> Starting the Merchant Agent (port:8001 log:$LOG_DIR/merchant_agent.log)..."
$UV_RUN_CMD --package ap2-samples python -m roles.merchant_agent >"$LOG_DIR/merchant_agent.log" 2>&1 &
pids+=($!)

# start credentials provider agent
echo "-> Starting the Credentials Provider (port:8002 log:$LOG_DIR/credentials_provider_agent.log)..."
$UV_RUN_CMD --package ap2-samples python -m roles.credentials_provider_agent >"$LOG_DIR/credentials_provider_agent.log" 2>&1 &
pids+=($!)

# start merchant payment processor agent
echo "-> Starting the Card Processor Agent (port:8003 log:$LOG_DIR/mpp_agent.log)..."
$UV_RUN_CMD --package ap2-samples python -m roles.merchant_payment_processor_agent >"$LOG_DIR/mpp_agent.log" 2>&1 &
pids+=($!)

echo ""
echo "All remote servers are starting."

# start shopping agent (foreground)
echo "Starting the Shopping Agent..."
$UV_RUN_CMD --package ap2-samples adk web --host 0.0.0.0 $AGENTS_DIR
