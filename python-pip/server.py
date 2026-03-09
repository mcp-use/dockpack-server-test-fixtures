from mcp.server.fastmcp import FastMCP

mcp = FastMCP("python-pip-fixture")


@mcp.tool()
def ping() -> str:
    """Returns pong"""
    return "pong"


if __name__ == "__main__":
    mcp.run()
