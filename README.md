# Homebrew Tap for LXC MCP

This is the official Homebrew tap for LXC MCP Server - a professional MCP server for LXC/LXD container management with seamless AI integration.

## Installation

```bash
# Add the tap
brew tap TB-Warp/lxc-mcp

# Install LXC MCP Server
brew install lxc-mcp

# Verify installation
lxc-mcp --help
```

## Usage

Both command names are available:
- `lxc-mcp` (recommended for AI integration)
- `lxc-mcp-server` (legacy compatibility)

## Warp AI Configuration

Add to your Warp MCP configuration:

```json
{
  "mcpServers": {
    "lxc-mcp": {
      "command": "lxc-mcp",
      "args": []
    }
  }
}
```

## Requirements

- Node.js (installed automatically)
- LXD (install with `brew install --cask lxd`)

## Repository

Source code: https://github.com/TB-Warp/lxc-mcp
