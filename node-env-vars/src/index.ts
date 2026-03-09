import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const name = process.env.SERVER_NAME;
if (!name) {
  throw new Error("SERVER_NAME environment variable is required");
}

const server = new McpServer({ name, version: "1.0.0" });

server.tool("ping", "Returns pong", {}, async () => ({
  content: [{ type: "text", text: "pong" }],
}));

const transport = new StdioServerTransport();
await server.connect(transport);
