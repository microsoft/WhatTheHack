import asyncio
import os
import sys
from argparse import ArgumentParser
from dotenv import load_dotenv

from contoso_retail_application import inventory_service, replenishment_service, shopping_service

async def run_mcp_service():

    service_lists: list[str] = ['shopping', 'replenishment', 'inventory']

    parser = ArgumentParser(description="Start the MCP service with provided or default configuration.")

    parser.add_argument('--service', required=True, help=f"The name of the service {service_lists}", choices=service_lists)
    parser.add_argument('--envFile', required=False, default='.env', help='Path to .env file (default: .env)')
    parser.add_argument('--host', required=False, default='0.0.0.0', help='Host IP or name for SSE (default: 0.0.0.0)')
    parser.add_argument('--port', required=False, type=int, default=8000, help='Port number for SSE (default: 8000)')

    # Parse the application arguments
    args = parser.parse_args()

    # Set up the Host name and port for the service
    mcp_service: str = args.service
    mcp_host: str = args.host
    mcp_port: int = args.port
    mcp_env_file: str = args.envFile

    if mcp_service not in service_lists:
        parser.print_help()
        sys.exit(1)

    # Check if envFile exists and load it
    if mcp_env_file and os.path.exists(mcp_env_file):
        load_dotenv(dotenv_path=mcp_env_file)
        print(f"Environment variables loaded from {mcp_env_file}")
    else:
        print(f"Env file '{mcp_env_file}' not found. Skipping environment loading.")

    service_dictionary = {
        'inventory' : inventory_service,
        'replenishment': replenishment_service,
        'shopping': shopping_service,
    }

    # Pick the service from the dictionary
    target_service = service_dictionary[mcp_service]

    # initialize the service
    service = target_service(host=mcp_host, port=mcp_port)

    # run the service with the streamable HTTP transport mode
    await service.run_streamable_http_async()

if __name__ == "__main__":
    asyncio.run(run_mcp_service())
