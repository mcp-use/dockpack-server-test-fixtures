"""Simple MCP server starter template using mcp-use."""

from mcp_use.server import MCPServer
from datetime import datetime

# Create server instance
server = MCPServer(
    name="my-mcp-server",
    version="1.0.0",
    instructions="A simple MCP server template", debug=True
)


@server.tool()
def greet(name: str) -> str:
    """Greet someone by name."""
    return f"Hello, {name}!"


@server.tool()
def add(a: int, b: int) -> int:
    """Add two numbers together."""
    return a + b


@server.tool()
def get_current_time() -> str:
    """Get the current date and time."""
    return datetime.now().isoformat()


if __name__ == "__main__":
    # Run with HTTP transport (default port 8000)
    # Use transport="stdio" for CLI-based MCP clients
    server.run(transport="streamable-http", port=8000)
