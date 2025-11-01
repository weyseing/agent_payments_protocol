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

# entrypoint
CMD ["tail", "-f", "/dev/null"]
