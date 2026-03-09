# Dockpack Server Test Fixtures

Test fixtures for the Dockpack server deployment pipeline. Each subdirectory contains a self-contained MCP server project with a `manifest.json` that declares how to set up, build, and run it.

## Manifest Schema

Each fixture contains a `manifest.json` with the following fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `runtime` | `"node"` \| `"python"` | yes | Language runtime |
| `setup` | `string` | no | Dependency installation command |
| `build` | `string` | no | Build command (omit if no build step) |
| `start` | `string` | no | Start command (omit to test auto-detection) |
| `env` | `object` | no | Environment variables required at runtime |
| `port` | `number` | no | Port the server listens on (if not stdio) |
| `workdir` | `string` | no | Working directory override |
| `expect` | `"pass"` | yes | Expected outcome |

## Test Fixtures

### Language / Runtime

| # | Fixture | Runtime | Package Manager | Build Step | Start Command | What it tests |
|---|---------|---------|-----------------|------------|---------------|---------------|
| 1 | `node-npm` | Node.js | npm | `npm run build` (tsc) | `node dist/index.js` | Standard TypeScript + npm project |
| 2 | `node-pnpm` | Node.js | pnpm | `pnpm build` | `pnpm start` | pnpm as package manager |
| 3 | `node-no-build` | Node.js | npm | none (plain JS) | `node index.js` | No build step, plain JavaScript |
| 4 | `python-pip` | Python | pip + requirements.txt | none | `python server.py` | Standard Python + pip project |
| 5 | `python-uv` | Python | uv + pyproject.toml | none | `uv run server.py` | uv as package manager |
| 6 | `python-no-start` | Python | pip + requirements.txt | none | none (auto-detect) | No start command in manifest |

### Config Variations

| # | Fixture | Runtime | What it tests |
|---|---------|---------|---------------|
| 7 | `node-script-start` | Node.js | Start command in `package.json` scripts, not in manifest |
| 8 | `node-monorepo` | Node.js | Monorepo with `packages/server/` — tests path resolution |
| 9 | `python-src-layout` | Python | `src/` layout with `python -m server` — tests module discovery |

### Edge Cases

| # | Fixture | Runtime | What it tests |
|---|---------|---------|---------------|
| 10 | `node-env-vars` | Node.js | Server requires env vars (`SERVER_NAME`, `SERVER_PORT`) to start |
| 11 | `node-custom-port` | Node.js | SSE transport on non-default port (9090) |
| 12 | `minimal` | Node.js | Single JS file, no package.json, no dependencies |
