"""
MCP Client for Weather Server Integration

This module provides a client interface to communicate with the MCP weather server
for integration with the Contoso AI Apps Backend.
"""

import asyncio
import json
import logging
import subprocess
import sys
from typing import Any, Dict, List, Optional
import tempfile
import os

# Configure logging
logger = logging.getLogger(__name__)

class MCPClientError(Exception):
    """Custom exception for MCP client errors"""
    pass

class MCPWeatherClient:
    """
    MCP client for communicating with the weather server.
    
    This client manages the lifecycle of the MCP weather server process
    and provides a simple interface for making weather requests.
    """
    
    def __init__(self, server_script_path: str):
        """
        Initialize the MCP weather client.
        
        Args:
            server_script_path: Path to the MCP weather server script
        """
        self.server_script_path = server_script_path
        self.server_process: Optional[subprocess.Popen] = None
        self._request_id = 0
    
    def _get_next_request_id(self) -> int:
        """Generate next request ID for JSON-RPC"""
        self._request_id += 1
        return self._request_id
    
    async def start_server(self) -> None:
        """Start the MCP weather server process"""
        try:
            # Start the server process with stdio communication
            self.server_process = subprocess.Popen(
                [sys.executable, self.server_script_path],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=0
            )
            
            logger.info("MCP weather server started")
            
            # Initialize the connection
            await self._initialize_connection()
            
        except Exception as e:
            logger.error(f"Failed to start MCP weather server: {e}")
            raise MCPClientError(f"Failed to start server: {str(e)}")
    
    async def _initialize_connection(self) -> None:
        """Initialize the MCP connection with handshake"""
        try:
            # Send initialization request
            init_request = {
                "jsonrpc": "2.0",
                "id": self._get_next_request_id(),
                "method": "initialize",
                "params": {
                    "protocolVersion": "2025-06-18",
                    "capabilities": {
                        "tools": {}
                    },
                    "clientInfo": {
                        "name": "contoso-weather-client",
                        "version": "1.0.0"
                    }
                }
            }
            
            response = await self._send_request(init_request)
            
            if "error" in response:
                raise MCPClientError(f"Initialization failed: {response['error']}")
            
            # Send initialized notification
            initialized_notification = {
                "jsonrpc": "2.0",
                "method": "notifications/initialized"
            }
            
            await self._send_notification(initialized_notification)
            logger.info("MCP connection initialized successfully")
            
        except Exception as e:
            logger.error(f"Failed to initialize MCP connection: {e}")
            raise MCPClientError(f"Initialization failed: {str(e)}")
    
    async def _send_request(self, request: Dict[str, Any]) -> Dict[str, Any]:
        """Send a JSON-RPC request and wait for response"""
        if not self.server_process or not self.server_process.stdin or not self.server_process.stdout:
            raise MCPClientError("Server process not available")
        
        try:
            # Send request
            request_line = json.dumps(request) + "\n"
            self.server_process.stdin.write(request_line)
            self.server_process.stdin.flush()
            
            # Read response
            response_line = self.server_process.stdout.readline()
            if not response_line:
                raise MCPClientError("No response from server")
            
            return json.loads(response_line.strip())
            
        except json.JSONDecodeError as e:
            raise MCPClientError(f"Invalid JSON response: {e}")
        except Exception as e:
            raise MCPClientError(f"Communication error: {e}")
    
    async def _send_notification(self, notification: Dict[str, Any]) -> None:
        """Send a JSON-RPC notification (no response expected)"""
        if not self.server_process or not self.server_process.stdin:
            raise MCPClientError("Server process not available")
        
        try:
            notification_line = json.dumps(notification) + "\n"
            self.server_process.stdin.write(notification_line)
            self.server_process.stdin.flush()
            
        except Exception as e:
            raise MCPClientError(f"Failed to send notification: {e}")
    
    async def list_tools(self) -> List[Dict[str, Any]]:
        """List available tools from the weather server"""
        try:
            request = {
                "jsonrpc": "2.0",
                "id": self._get_next_request_id(),
                "method": "tools/list"
            }
            
            response = await self._send_request(request)
            
            if "error" in response:
                raise MCPClientError(f"Error listing tools: {response['error']}")
            
            return response.get("result", {}).get("tools", [])
            
        except Exception as e:
            logger.error(f"Failed to list tools: {e}")
            raise MCPClientError(f"Failed to list tools: {str(e)}")
    
    async def get_weather_forecast(self, latitude: float, longitude: float) -> Dict[str, Any]:
        """
        Get weather forecast for the specified coordinates.
        
        Args:
            latitude: Latitude coordinate
            longitude: Longitude coordinate
            
        Returns:
            Weather forecast data
        """
        try:
            request = {
                "jsonrpc": "2.0",
                "id": self._get_next_request_id(),
                "method": "tools/call",
                "params": {
                    "name": "get_weather_forecast",
                    "arguments": {
                        "latitude": latitude,
                        "longitude": longitude
                    }
                }
            }
            
            response = await self._send_request(request)
            
            if "error" in response:
                raise MCPClientError(f"Error getting weather forecast: {response['error']}")
            
            result = response.get("result", {})
            content = result.get("content", [])
            
            if content and len(content) > 0:
                text_content = content[0].get("text", "{}")
                return json.loads(text_content)
            else:
                raise MCPClientError("No weather data returned")
                
        except json.JSONDecodeError as e:
            raise MCPClientError(f"Invalid weather data format: {e}")
        except Exception as e:
            logger.error(f"Failed to get weather forecast: {e}")
            raise MCPClientError(f"Failed to get weather forecast: {str(e)}")
    
    async def get_weather_summary(self, latitude: float, longitude: float) -> str:
        """
        Get formatted weather summary for the specified coordinates.
        
        Args:
            latitude: Latitude coordinate
            longitude: Longitude coordinate
            
        Returns:
            Formatted weather summary string
        """
        try:
            request = {
                "jsonrpc": "2.0",
                "id": self._get_next_request_id(),
                "method": "tools/call",
                "params": {
                    "name": "get_weather_summary",
                    "arguments": {
                        "latitude": latitude,
                        "longitude": longitude
                    }
                }
            }
            
            response = await self._send_request(request)
            
            if "error" in response:
                raise MCPClientError(f"Error getting weather summary: {response['error']}")
            
            result = response.get("result", {})
            content = result.get("content", [])
            
            if content and len(content) > 0:
                return content[0].get("text", "No weather summary available")
            else:
                raise MCPClientError("No weather summary returned")
                
        except Exception as e:
            logger.error(f"Failed to get weather summary: {e}")
            raise MCPClientError(f"Failed to get weather summary: {str(e)}")
    
    async def stop_server(self) -> None:
        """Stop the MCP weather server process"""
        if self.server_process:
            try:
                self.server_process.terminate()
                self.server_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.server_process.kill()
                self.server_process.wait()
            finally:
                self.server_process = None
            
            logger.info("MCP weather server stopped")

# Synchronous wrapper for use in the Azure Functions environment
class SyncMCPWeatherClient:
    """
    Synchronous wrapper for the MCP weather client.
    
    This provides a synchronous interface for use in Azure Functions
    where async/await patterns may not be ideal.
    """
    
    def __init__(self, server_script_path: str):
        self.server_script_path = server_script_path
        self._client: Optional[MCPWeatherClient] = None
        self._loop: Optional[asyncio.AbstractEventLoop] = None
    
    def _ensure_client(self) -> MCPWeatherClient:
        """Ensure the async client is initialized"""
        if not self._client:
            self._client = MCPWeatherClient(self.server_script_path)
            
            # Get or create event loop
            try:
                self._loop = asyncio.get_event_loop()
            except RuntimeError:
                self._loop = asyncio.new_event_loop()
                asyncio.set_event_loop(self._loop)
            
            # Start the server
            self._loop.run_until_complete(self._client.start_server())
        
        return self._client
    
    def get_weather_forecast(self, latitude: float, longitude: float) -> Dict[str, Any]:
        """
        Get weather forecast synchronously.
        
        Args:
            latitude: Latitude coordinate
            longitude: Longitude coordinate
            
        Returns:
            Weather forecast data
        """
        client = self._ensure_client()
        if not self._loop:
            raise MCPClientError("Event loop not available")
        
        return self._loop.run_until_complete(
            client.get_weather_forecast(latitude, longitude)
        )
    
    def get_weather_summary(self, latitude: float, longitude: float) -> str:
        """
        Get weather summary synchronously.
        
        Args:
            latitude: Latitude coordinate
            longitude: Longitude coordinate
            
        Returns:
            Formatted weather summary string
        """
        client = self._ensure_client()
        if not self._loop:
            raise MCPClientError("Event loop not available")
        
        return self._loop.run_until_complete(
            client.get_weather_summary(latitude, longitude)
        )
    
    def close(self) -> None:
        """Close the client and clean up resources"""
        if self._client and self._loop:
            self._loop.run_until_complete(self._client.stop_server())
        
        if self._loop and not self._loop.is_closed():
            self._loop.close()
        
        self._client = None
        self._loop = None
