# Python MCP Server Starter

A minimal [mcp-use](https://manufact.com) Python server template.

## Quick Start

```bash
pip install -r requirements.txt
python server.py
```

The server runs at `http://localhost:8000/mcp`.

## Example Tools

- `greet(name)` - Returns a greeting
- `add(a, b)` - Adds two numbers
- `get_current_time()` - Returns current timestamp

## Adding Tools

```python
@server.tool()
def my_tool(arg: str) -> str:
    """Tool description shown to clients."""
    return f"Result: {arg}"
```

## Documentation

See the full [mcp-use Python docs](https://mcp-use.com/docs/python/server/index).
