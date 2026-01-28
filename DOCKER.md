# Docker Setup

Run the litellm-copilot proxy using Docker and docker-compose.

## Quick Start

### Option 1: Using Environment Variable

```bash
# Set your GitHub token
export GITHUB_TOKEN=ghp_your_token_here

# Start the proxy
docker compose up
```

### Option 2: Using Docker Secrets (Recommended)

```bash
# Create a file with your token (no trailing newline)
echo -n "ghp_your_token_here" > github_token.txt

# Start the proxy
docker compose up
```

### Option 3: Using Token Command (Requires Custom Image)

**Note:** This option requires building a custom Docker image with the necessary CLI tools (like `op` for 1Password or `security` for macOS Keychain) installed. The base image doesn't include these tools.

Example custom Dockerfile:
```dockerfile
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

# Install 1Password CLI (example)
RUN curl -sSO https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb && \
    dpkg -i 1password-cli-amd64-latest.deb && \
    rm 1password-cli-amd64-latest.deb

WORKDIR /app
COPY config.yaml /app/config.yaml
# ... rest of Dockerfile
```

## Configuration

### Environment Variables

- `GITHUB_TOKEN` - Your GitHub Personal Access Token (direct)
- `COPILOT_PROXY_TOKEN_CMD` - Command to retrieve token (requires custom image with CLI tools)
- `GITHUB_TOKEN_FILE` - Host path to file containing token (default: `./github_token.txt`, mounted as `/run/secrets/github_token` in container)
- `PORT` - Port to run proxy on (default: `4000`)

### Custom Configuration

The default `config.yaml` is included in the Docker image. To use a custom configuration:

1. Create or modify `config.yaml` in the project directory
2. The docker-compose.yml already mounts it at `/app/config.yaml`

Or remove the volume mount to use the default configuration.

## Building

Build the image:

```bash
docker compose build
```

## Usage

The proxy will be available at `http://localhost:4000` once started.

### Using with AI Tools

Configure your AI tools to use the proxy:

```bash
# For Anthropic Claude
export ANTHROPIC_BASE_URL="http://localhost:4000"
export ANTHROPIC_AUTH_TOKEN="fake-key"

# For OpenAI-compatible tools
export OPENAI_BASE_URL="http://localhost:4000"
export OPENAI_API_KEY="fake-key"
```

## Troubleshooting

View logs:
```bash
docker compose logs -f
```

Restart the service:
```bash
docker compose restart
```

Stop and remove containers:
```bash
docker compose down
```

### Common Issues

**"No token found" error:**
- Ensure `GITHUB_TOKEN` is set, OR
- Create `github_token.txt` with your token (no trailing newline), OR  
- Set `COPILOT_PROXY_TOKEN_CMD` with a custom image that has the CLI tools installed

**Config file mount fails:**
- If you don't have a custom config, remove the volume mount from `docker-compose.yml` to use the default config from the image
