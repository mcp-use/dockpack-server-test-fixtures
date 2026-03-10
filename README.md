# Dockpack Server Test Fixtures

Test fixtures for the Dockpack server deployment pipeline. Each subdirectory contains a self-contained MCP server project with:

- `manifest.json` — user-provided inputs (what a real user would specify)
- `expected.Dockerfile` — the known-good Dockerfile that Dockpack should generate

Dockpack auto-detects runtime and package manager from project files. The manifest does **not** specify these — that's what we're testing.

## Manifest Schema

Each fixture contains a `manifest.json` with the following fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `build` | `string` | no | Build command (omit if no build step) |
| `start` | `string` | no | Start command (omit to test auto-detection) |
| `env` | `object` | no | Environment variables required at runtime |
| `port` | `number` | no | Port the server listens on (if not stdio) |
| `root_dir` | `string` | no | Subdirectory to use as project root (monorepos) |
| `expect` | `"pass"` | yes | Expected outcome |

## Test Fixtures

### Language / Runtime

| # | Fixture | Runtime | What it tests |
|---|---------|---------|---------------|
| 1 | `node-npm` | Node.js / npm | Standard TypeScript project with `npm run build` |
| 2 | `node-pnpm` | Node.js / pnpm | pnpm detected from build/start commands, corepack setup |
| 3 | `node-no-build` | Node.js / npm | Plain JavaScript, no build step |
| 4 | `python-pip` | Python / pip | Standard pip + `requirements.txt` project |
| 5 | `python-uv` | Python / uv | uv + `pyproject.toml` project |
| 6 | `python-no-start` | Python / pip | No start command — tests auto-detection of entry point |

### Config Variations

| # | Fixture | Runtime | What it tests |
|---|---------|---------|---------------|
| 7 | `node-script-start` | Node.js | Start command defined in `package.json` scripts, not manifest |
| 8 | `node-monorepo` | Node.js | Workspace monorepo — tests workspace-aware Dockerfile template |
| 9 | `node-root-dir` | Node.js | Monorepo with `root_dir` — tests subdirectory resolution |
| 10 | `python-src-layout` | Python | `src/` layout with `python -m server` — full source copy for install |

### Edge Cases

| # | Fixture | Runtime | What it tests |
|---|---------|---------|---------------|
| 11 | `node-env-vars` | Node.js | Server requires env vars (`SERVER_NAME`, `SERVER_PORT`) to start |
| 12 | `node-custom-port` | Node.js | SSE transport on non-default port (9090) |
| 13 | `minimal` | Node.js | Single JS file, no `package.json` — minimal Dockerfile template |
| 14 | `node-existing-dockerfile` | Node.js | Project already has a `Dockerfile` — Dockpack uses it as-is |

### mcp-use Templates

Real-world fixtures scaffolded from `npx create-mcp-use-app`. These are synced daily via the `sync_templates.yml` workflow.

| # | Fixture | Source | What it tests |
|---|---------|--------|---------------|
| 15 | `mcp-use-starter` | `npx create-mcp-use-app --template starter` | Full-featured MCP server with tools, resources, prompts |
| 16 | `mcp-use-mcp-apps` | `npx create-mcp-use-app --template mcp-apps` | MCP server with OpenAI Apps SDK integration |
| 17 | `mcp-use-python-starter` | `mcp-use/python-server-starter` repo | Python MCP server with mcp-use framework |

## CI Workflows

### `build_dockerfiles.yml`

Builds each `expected.Dockerfile` with Docker to verify they produce working images. Runs on push, PR, and can be triggered manually.

### `sync_templates.yml`

Runs daily at 06:00 UTC. Re-scaffolds mcp-use templates from the latest published packages and re-clones the Python starter. Auto-commits if anything changed and triggers the Docker build workflow.
