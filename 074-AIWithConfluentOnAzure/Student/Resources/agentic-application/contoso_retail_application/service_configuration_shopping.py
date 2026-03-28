from mcp.server import FastMCP


def shopping_service(host: str = "0.0.0.0", port: int = 8082):

    # Declare the MCP service
    product_mcp = FastMCP(name="Shopping Service", host=host, port=port)

    @product_mcp.tool(description="Says Hello")
    async def say_hello():
        return "Hello"

    return product_mcp