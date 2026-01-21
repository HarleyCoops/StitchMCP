# Product Requirements Document (PRD): Stitch MCP Exploration & Setup

## 1. Executive Summary
The goal of this project is to successfully install, configure, and explore the capabilities of the Google Stitch MCP (Model Context Protocol) server. Stitch allows for AI-driven UI generation for mobile and web applications. We will set up the necessary environment, connect it to our development tools (VSCode/Claude Code), and validat functionality by generating a sample UI.

## 2. Objectives
- **Installation**: Ensure Google Cloud SDK and necessary components are installed.
- **Authentication**: Authenticate with Google Cloud using both standard and Application Default Credentials (ADC).
- **Configuration**: Enable the Stitch API and configure IAM permissions.
- **Integration**: Connect the Stitch MCP server to a client (VSCode or Claude Code).
- **Exploration**: Generate a sample web or mobile UI component to verify the setup.
- **Documentation**: Record the setup process and findings for future reference.

## 3. Technical Requirements

### 3.1 Prerequisites
- **OS**: Windows (Current User Environment)
- **Tools**: 
    - Google Cloud SDK (Local install at `./google-cloud-sdk/bin/gcloud`)
    - Node.js / NPM (for running clients/scripts if needed)
    - MCP Client (VSCode with MCP extension or Claude Code)

### 3.2 Authentication & Security
- **Double-Layer Auth**:
    - `gcloud auth login` (User identity)
    - `gcloud auth application-default login` (ADC for API access)
- **IAM Roles**:
    - User must have `roles/serviceusage.serviceUsageConsumer` on the target GCP project.
- **Secrets Management**:
    - `GOOGLE_CLOUD_PROJECT`: Target Project ID.
    - `STITCH_ACCESS_TOKEN`: Generated via `gcloud auth application-default print-access-token`.

### 3.3 API Dependencies
- `stitch.googleapis.com` must be enabled on the target project.

## 4. Implementation Plan

### Phase 1: Environment Discovery & Setup
1. Verify `gcloud` installation.
2. Confirm active Google Cloud Project.
3. Perform authentication procedures.

### Phase 2: Project Configuration
1. Enable `stitch.googleapis.com` API.
2. Verify/Grant IAM permissions.
3. Generate `.env` file with necessary credentials.

### Phase 3: Client Connection
1. Configure `mcp.json` for VSCode OR connect via Claude Code.
2. Connection Settings:
    - Server URL: `https://stitch.googleapis.com/mcp`
    - Headers: `Authorization`, `X-Goog-User-Project`.

### Phase 4: Validation (The "Build")
1. Request Stitch to generate a simple "Login Page" or "Dashboard" component.
2. Review the generated output (HTML/CSS/React).
3. Validate that the design conforms to requested aesthetics (if applicable).

## 5. Success Metrics
- `gcloud` commands execute without error.
- Stitch API is enabled.
- MCP Client successfully connects to the Stitch server (no "Connection refused" or 403 errors).
- A visible UI component is generated and saved to the codebase.
