import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import express from "express";

const PORT = 9090;
const app = express();

const server = new McpServer({ name: "node-custom-port-fixture", version: "1.0.0" });

server.tool("ping", "Returns pong", {}, async () => ({
  content: [{ type: "text", text: "pong" }],
}));

app.get("/sse", async (_req, res) => {
  const transport = new SSEServerTransport("/messages", res);
  await server.connect(transport);
});

app.listen(PORT, () => {
  console.log(`MCP server listening on port ${PORT}`);
});
