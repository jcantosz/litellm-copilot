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
# Create a file with your token
echo "ghp_your_token_here" > github_token.txt

# Start the proxy
docker compose up
```

### Option 3: Using Token Command

```bash
# Set command to retrieve token (e.g., from 1Password)
export COPILOT_PROXY_TOKEN_CMD='op read "op://Vault/Item/field"'

# Start the proxy
docker compose up
```

## Configuration

### Environment Variables

- `GITHUB_TOKEN` - Your GitHub Personal Access Token (direct)
- `COPILOT_PROXY_TOKEN_CMD` - Command to retrieve token from secret manager
- `GITHUB_TOKEN_FILE` - Path to file containing token (default: `./github_token.txt`)
- `PORT` - Port to run proxy on (default: `4000`)

### Custom Configuration

To use a custom `config.yaml`, modify the volume mount in `docker-compose.yml` or edit the existing `config.yaml` file.

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
