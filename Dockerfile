FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

WORKDIR /app

# Copy config file
COPY config.yaml /app/config.yaml

# Create script to handle token retrieval and start litellm
COPY <<'EOF' /app/start.sh
#!/bin/bash
set -e

# Handle token from various sources (in order of precedence)
# 1. Docker secret file
if [ -f /run/secrets/github_token ]; then
  echo "Using token from Docker secret..."
  export GITHUB_TOKEN=$(cat /run/secrets/github_token | tr -d '\n\r')
# 2. Command to retrieve token (requires custom image with CLI tools)
elif [ -n "$COPILOT_PROXY_TOKEN_CMD" ]; then
  echo "Retrieving token using COPILOT_PROXY_TOKEN_CMD..."
  export GITHUB_TOKEN=$(eval "$COPILOT_PROXY_TOKEN_CMD")
fi

# 3. Verify we have a token from one of the above methods or GITHUB_TOKEN env var
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: No token found."
  echo "Provide a token using one of these methods:"
  echo "  1. Docker secret at /run/secrets/github_token"
  echo "  2. COPILOT_PROXY_TOKEN_CMD environment variable (requires custom image with CLI tools)"
  echo "  3. GITHUB_TOKEN environment variable"
  exit 1
fi

# Start litellm proxy
echo "Starting litellm proxy on port ${PORT:-4000}..."
exec uvx --python 3.13 --from 'litellm[proxy]' litellm --config /app/config.yaml --port ${PORT:-4000}
EOF

RUN chmod +x /app/start.sh

# Expose default port
EXPOSE 4000

ENTRYPOINT ["/app/start.sh"]
