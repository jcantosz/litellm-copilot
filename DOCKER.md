# Docker Setup

Run the litellm-copilot proxy using Docker and docker-compose.

## Quick Start

1. Copy the template environment file:
```bash
cp .env.tmpl .env
```

2. Edit `.env` and set your GitHub token:
```bash
GITHUB_TOKEN=ghp_your_token_here
PORT=4000
```

3. Start the proxy:
```bash
docker compose up
```

The proxy will be available at `http://localhost:4000`.

## Configuration

### Environment Variables

Configure these in your `.env` file:

- `GITHUB_TOKEN` - Your GitHub Personal Access Token (required)
- `COPILOT_PROXY_TOKEN_CMD` - Command to retrieve token (optional fallback, requires custom image with CLI tools)
- `PORT` - Port to run proxy on (default: `4000`)

### Token Authentication

The startup script prefers `GITHUB_TOKEN` and falls back to `COPILOT_PROXY_TOKEN_CMD` if the token is not set.

**Using COPILOT_PROXY_TOKEN_CMD** requires building a custom Docker image with the necessary CLI tools installed (like `op` for 1Password or `security` for macOS Keychain).

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
- Ensure `GITHUB_TOKEN` is set in your `.env` file, OR
- Set `COPILOT_PROXY_TOKEN_CMD` in `.env` (requires custom image with CLI tools installed)

**Config file mount fails:**
- If you don't have a custom config, remove the volume mount from `docker-compose.yml` to use the default config from the image
