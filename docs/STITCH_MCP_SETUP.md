# Stitch MCP Server Setup

This guide integrates the Stitch MCP server into Fitola using the official Stitch MCP helper CLI.

## Overview

Stitch MCP lets compatible coding agents generate UI designs and export code by talking to Stitch. Stitch is an experimental Google Labs UI tool that supports:

- UI generation from prompts, sketches, or screenshots
- Export to Figma or front-end code (HTML/CSS/React)
- Gemini 2.5 Flash (default) and Gemini 2.5 Pro or Gemini 3 Pro Thinking (experimental)
- Free tier usage limits (daily credits and redesign credits) managed in Stitch settings
- Optional privacy controls to opt-out of training on future Stitch conversations

## Prerequisites

- Node.js 18+ with `npx`
- Google Cloud CLI (`gcloud`)
- A Google Cloud project with Stitch API enabled
- Access to Stitch via https://stitch.withgoogle.com

## 1. Run the Setup Helper

```bash
npx @_davideast/stitch-mcp init
```

Follow the prompts to:

1. Authenticate with Google Cloud
2. Select your project
3. Enable the Stitch API
4. Generate MCP configuration

## 2. Configure `mcp.json`

Use the generated output from the setup helper. For this repo, update the root `mcp.json` with:

```json
{
  "servers": {
    "stitch": {
      "command": "npx",
      "args": ["@_davideast/stitch-mcp", "proxy"],
      "env": {
        "STITCH_PROJECT_ID": "your-google-cloud-project-id"
      }
    }
  }
}
```

If you prefer to reuse your existing `gcloud` configuration, set:

```json
"env": {
  "STITCH_USE_SYSTEM_GCLOUD": "1",
  "STITCH_PROJECT_ID": "your-google-cloud-project-id"
}
```

## 3. Environment Variables

Add the following to `.env` (see `.env.example`):

```
STITCH_PROJECT_ID=your_google_cloud_project_id
STITCH_USE_SYSTEM_GCLOUD=1
```

## 4. Verify

```bash
npx @_davideast/stitch-mcp doctor
```

## 5. Usage Notes

- Stitch daily credits and redesign credits are enforced by Stitch settings.
- Review privacy preferences on the Stitch settings page if you want to opt-out of training on future Stitch conversations.

