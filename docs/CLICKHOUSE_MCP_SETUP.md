# ClickHouse MCP Server Setup

This guide integrates the ClickHouse MCP server into Fitola to support workflow management and database orchestration tasks.

## Overview

ClickHouse MCP exposes safe, read-only tooling for ClickHouse and optional chDB access. Fitola uses this MCP server to let compatible agents inspect ClickHouse data during workflow planning and orchestration.

## Prerequisites

- Python 3.10+
- [`uv`](https://docs.astral.sh/uv/) installed (recommended by ClickHouse MCP)
- ClickHouse connection credentials

## 1. Configure `mcp.json`

Add the ClickHouse MCP server entry to the root `mcp.json` (already included in this repo):

```json
{
  "servers": {
    "clickhouse": {
      "command": "uv",
      "args": [
        "run",
        "--with",
        "mcp-clickhouse",
        "--python",
        "3.10",
        "mcp-clickhouse"
      ],
      "env": {
        "CLICKHOUSE_HOST": "YOUR_CLICKHOUSE_HOST_HERE",
        "CLICKHOUSE_PORT": "8443",
        "CLICKHOUSE_USER": "default",
        "CLICKHOUSE_PASSWORD": "YOUR_CLICKHOUSE_PASSWORD_HERE",
        "CLICKHOUSE_SECURE": "true",
        "CLICKHOUSE_VERIFY": "true",
        "CLICKHOUSE_CONNECT_TIMEOUT": "30",
        "CLICKHOUSE_SEND_RECEIVE_TIMEOUT": "30"
      }
    }
  }
}
```

Update the values to point to your ClickHouse instance.

## 2. Environment Variables

Use the following variables for the ClickHouse connection:

- `CLICKHOUSE_HOST`
- `CLICKHOUSE_PORT`
- `CLICKHOUSE_USER`
- `CLICKHOUSE_PASSWORD` (replace the placeholder, or remove it from `mcp.json` and export it from your shell/secret manager)
- `CLICKHOUSE_SECURE` (`true`/`false`)
- `CLICKHOUSE_VERIFY` (`true`/`false`)
- `CLICKHOUSE_CONNECT_TIMEOUT`
- `CLICKHOUSE_SEND_RECEIVE_TIMEOUT`

## 3. Authentication (HTTP/SSE Optional)

If you expose the ClickHouse MCP server over HTTP or SSE, set an auth token:

```bash
export CLICKHOUSE_MCP_AUTH_TOKEN="your-generated-token"
```

For local development only, you can disable authentication:

```bash
export CLICKHOUSE_MCP_AUTH_DISABLED=true
```

## 4. Verify

When running with HTTP/SSE transport, the MCP server exposes a health check endpoint (default `http://localhost:8000/health` unless you override the MCP server port):

```bash
curl http://localhost:8000/health
```
