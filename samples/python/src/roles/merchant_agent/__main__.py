# samples/python/src/roles/merchant_agent/__main__.py

"""Main for the merchant agent."""

from collections.abc import Sequence
from absl import app
from roles.merchant_agent.agent_executor import MerchantAgentExecutor
from common import server

AGENT_MERCHANT_PORT = 8001

def main(argv: Sequence[str]) -> None:
  # agent card
  agent_card = server.load_local_agent_card(__file__)
  # run server
  server.run_agent_blocking(
      port=AGENT_MERCHANT_PORT,
      agent_card=agent_card,
      executor=MerchantAgentExecutor(agent_card.capabilities.extensions),
      rpc_url="/a2a/merchant_agent",
  )

if __name__ == "__main__":
  app.run(main)
