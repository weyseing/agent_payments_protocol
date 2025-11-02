# !/bin/bash

# agent card
curl -s http://localhost:8001/a2a/merchant_agent/.well-known/agent-card.json | jq .



