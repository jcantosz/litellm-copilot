FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

WORKDIR /app

# Copy config file
COPY config.yaml /app/config.yaml

# Create script to handle token retrieval and start litellm
COPY <<'EOF' /app/start.sh
#!/bin/bash
set -e

# Handle token from environment variables (in order of precedence)
# 1. GITHUB_TOKEN environment variable (preferred)
if [ -z "$GITHUB_TOKEN" ] && [ -n "$COPILOT_PROXY_TOKEN_CMD" ]; then
  # 2. Command to retrieve token (fallback, requires custom image with CLI tools)
  echo "Retrieving token using COPILOT_PROXY_TOKEN_CMD..."
  export GITHUB_TOKEN=$(eval "$COPILOT_PROXY_TOKEN_CMD")
fi

# Verify we have a token
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: No token found."
  echo "Set GITHUB_TOKEN in .env file or provide COPILOT_PROXY_TOKEN_CMD"
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
