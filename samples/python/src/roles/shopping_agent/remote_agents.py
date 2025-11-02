# samples/python/src/roles/shopping_agent/remote_agents.py

"""Clients used by the shopping agent to communicate with remote agents.

Clients request activation of the Agent Payments Protocol extension by including
the X-A2A-Extensions header in each HTTP request.

This registry serves as the initial allowlist of remote agents that the shopping
agent trusts.
"""

from common.a2a_extension_utils import EXTENSION_URI
from common.payment_remote_a2a_client import PaymentRemoteA2aClient


credentials_provider_client = PaymentRemoteA2aClient(
    name="credentials_provider",
    base_url="http://localhost:8002/a2a/credentials_provider",
    required_extensions={
        EXTENSION_URI,
    },
)


merchant_agent_client = PaymentRemoteA2aClient(
    name="merchant_agent",
    base_url="http://localhost:8001/a2a/merchant_agent",
    required_extensions={
        EXTENSION_URI,
    },
)
