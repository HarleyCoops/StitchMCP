# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is for exploring and setting up the **Google Stitch MCP (Model Context Protocol) server**. Stitch enables AI-driven UI generation for mobile and web applications through the Model Context Protocol.

## Key Project Goals

1. Install and configure Google Cloud SDK for Stitch API access
2. Set up authentication (both user identity and Application Default Credentials)
3. Connect Stitch MCP server to development tools (VSCode/Claude Code)
4. Generate and validate sample UI components using Stitch

## Authentication Architecture

Stitch requires **double-layer authentication**: 

1. **User Identity**: `gcloud auth login`
2. **Application Default Credentials (ADC)**: `gcloud auth application-default login`

Required environment variables:
- `GOOGLE_CLOUD_PROJECT`: Target GCP project ID
- `STITCH_ACCESS_TOKEN`: Generated via `gcloud auth application-default print-access-token`

IAM Requirements:
- User must have `roles/serviceusage.serviceUsageConsumer` on the target GCP project
- The `stitch.googleapis.com` API must be enabled

## Common Commands

### Google Cloud SDK Setup
```bash
# Install Google Cloud SDK (install.bat is in google-cloud-sdk/)
.\google-cloud-sdk\install.bat

# Verify installation
gcloud --version

# Authenticate user
gcloud auth login

# Authenticate for API access (ADC)
gcloud auth application-default login

# Generate access token
gcloud auth application-default print-access-token

# Set active project
gcloud config set project YOUR_PROJECT_ID

# Enable Stitch API
gcloud services enable stitch.googleapis.com
```

### MCP Connection

The Stitch MCP server endpoint:
- **URL**: `https://stitch.googleapis.com/mcp`
- **Required Headers**:
  - `Authorization: Bearer <access-token>`
  - `X-Goog-User-Project: <project-id>`

## Project Structure

- [instructions.md](instructions.md) - Detailed Product Requirements Document (PRD) for Stitch MCP setup
- [Subagent.txt](Subagent.txt) - Reference to Google Antigravity IDE MCP documentation
- `google-cloud-sdk/` - Local Google Cloud SDK installation
- `.claude/` - Claude Code configuration with web permissions for Google domains

## Key Documentation

- Primary setup guide: [instructions.md](instructions.md)
- Google Antigravity MCP docs: https://antigravity.google/docs/mcp
- Implementation follows 4-phase approach:
  1. Environment Discovery & Setup
  2. Project Configuration
  3. Client Connection
  4. Validation (generate sample UI)

## Success Validation

To verify successful setup:
1. All `gcloud` commands execute without errors
2. Stitch API is enabled on target project
3. MCP client connects successfully (no 403 or connection errors)
4. Can generate a UI component (e.g., login page or dashboard)
5. Generated output is valid HTML/CSS/React code
