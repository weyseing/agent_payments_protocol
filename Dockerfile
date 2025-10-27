FROM python:3.11-slim

# work directory
WORKDIR /app

# install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.cargo/bin/uv /usr/local/bin/uv || \
    mv /root/.local/bin/uv /usr/local/bin/uv

# copy files
COPY . /app

# install AP2 python library (not yet published to PyPI)
RUN uv pip install --system git+https://github.com/google-agentic-commerce/AP2.git@main

# entrypoint
CMD ["tail", "-f", "/dev/null"]
