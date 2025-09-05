#!/usr/bin/env python3
"""
MCP Weather Server for National Weather Service API Integration

This server provides weather tools for the Contoso AI Apps Backend using the 
Model Context Protocol (MCP). It integrates with the National Weather Service API
to provide weather forecasts based on latitude and longitude coordinates.
"""

import asyncio
import json
import logging
import os
from typing import Any, Sequence
import httpx
from mcp.server.models import InitializationOptions
import mcp.types as types
from mcp.server import NotificationOptions, Server
import mcp.server.stdio

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("weather-mcp-server")

# National Weather Service API base URL
NWS_API_BASE = "https://api.weather.gov"

# Initialize the MCP server
server = Server("weather-mcp-server")

class WeatherAPIError(Exception):
    """Custom exception for weather API errors"""
    pass

async def get_weather_forecast(lat: float, lon: float) -> dict[str, Any]:
    """
    Get weather forecast for given latitude and longitude using National Weather Service API
    
    Args:
        lat: Latitude coordinate
        lon: Longitude coordinate
        
    Returns:
        Dictionary containing weather forecast data
        
    Raises:
        WeatherAPIError: If API request fails or returns invalid data
    """
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            # First, get the grid points for the coordinates
            points_url = f"{NWS_API_BASE}/points/{lat:.4f},{lon:.4f}"
            logger.info(f"Fetching grid points from: {points_url}")
            
            points_response = await client.get(points_url)
            points_response.raise_for_status()
            points_data = points_response.json()
            
            if "properties" not in points_data:
                raise WeatherAPIError("Invalid response from points API")
            
            # Extract forecast URL from points response
            forecast_url = points_data["properties"].get("forecast")
            if not forecast_url:
                raise WeatherAPIError("No forecast URL found in points response")
            
            logger.info(f"Fetching forecast from: {forecast_url}")
            
            # Get the forecast
            forecast_response = await client.get(forecast_url)
            forecast_response.raise_for_status()
            forecast_data = forecast_response.json()
            
            if "properties" not in forecast_data or "periods" not in forecast_data["properties"]:
                raise WeatherAPIError("Invalid forecast response format")
            
            return forecast_data["properties"]
            
    except httpx.HTTPStatusError as e:
        if e.response.status_code == 404:
            raise WeatherAPIError(f"Weather data not available for coordinates {lat}, {lon}")
        else:
            raise WeatherAPIError(f"HTTP error {e.response.status_code}: {e.response.text}")
    except httpx.RequestError as e:
        raise WeatherAPIError(f"Request failed: {str(e)}")
    except json.JSONDecodeError as e:
        raise WeatherAPIError(f"Invalid JSON response: {str(e)}")

def format_weather_summary(forecast_data: dict[str, Any]) -> str:
    """
    Format weather forecast data into a human-readable summary
    
    Args:
        forecast_data: Weather forecast data from NWS API
        
    Returns:
        Formatted weather summary string
    """
    try:
        periods = forecast_data.get("periods", [])
        if not periods:
            return "No weather forecast data available."
        
        # Get the first few periods (current and next few days)
        summary_periods = periods[:6]  # Current + next 5 periods
        
        summary = []
        summary.append("=== Weather Forecast ===\n")
        
        for period in summary_periods:
            name = period.get("name", "Unknown Period")
            temperature = period.get("temperature", "Unknown")
            temperature_unit = period.get("temperatureUnit", "F")
            short_forecast = period.get("shortForecast", "No forecast available")
            detailed_forecast = period.get("detailedForecast", "")
            
            summary.append(f"{name}:")
            summary.append(f"  Temperature: {temperature}°{temperature_unit}")
            summary.append(f"  Conditions: {short_forecast}")
            if detailed_forecast and detailed_forecast != short_forecast:
                summary.append(f"  Details: {detailed_forecast}")
            summary.append("")
        
        return "\n".join(summary)
        
    except Exception as e:
        logger.error(f"Error formatting weather summary: {e}")
        return f"Error formatting weather data: {str(e)}"

@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    """
    List available tools.
    Each tool specifies its arguments using JSON Schema validation.
    """
    return [
        types.Tool(
            name="get_weather_forecast",
            description="Get current weather forecast for a specific location using latitude and longitude coordinates. This tool uses the National Weather Service API to provide detailed weather information including temperature, conditions, and forecasts for the next several days.",
            inputSchema={
                "type": "object",
                "properties": {
                    "latitude": {
                        "type": "number",
                        "description": "Latitude coordinate (decimal degrees, e.g., 40.7128 for New York City)",
                        "minimum": -90,
                        "maximum": 90
                    },
                    "longitude": {
                        "type": "number", 
                        "description": "Longitude coordinate (decimal degrees, e.g., -74.0060 for New York City)",
                        "minimum": -180,
                        "maximum": 180
                    }
                },
                "required": ["latitude", "longitude"]
            }
        ),
        types.Tool(
            name="get_weather_summary",
            description="Get a formatted weather summary suitable for presentation to yacht tour clients. This provides a concise overview of weather conditions to help clients make informed decisions about their yacht tour.",
            inputSchema={
                "type": "object",
                "properties": {
                    "latitude": {
                        "type": "number",
                        "description": "Latitude coordinate (decimal degrees)",
                        "minimum": -90,
                        "maximum": 90
                    },
                    "longitude": {
                        "type": "number",
                        "description": "Longitude coordinate (decimal degrees)", 
                        "minimum": -180,
                        "maximum": 180
                    }
                },
                "required": ["latitude", "longitude"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(
    name: str, arguments: dict[str, Any] | None
) -> list[types.TextContent | types.ImageContent | types.EmbeddedResource]:
    """
    Handle tool calls for weather-related functionality.
    """
    try:
        if name == "get_weather_forecast":
            if not arguments:
                raise ValueError("Missing required arguments")
            
            latitude = arguments.get("latitude")
            longitude = arguments.get("longitude")
            
            if latitude is None or longitude is None:
                raise ValueError("Both latitude and longitude are required")
            
            # Validate coordinate ranges
            if not (-90 <= latitude <= 90):
                raise ValueError("Latitude must be between -90 and 90 degrees")
            if not (-180 <= longitude <= 180):
                raise ValueError("Longitude must be between -180 and 180 degrees")
            
            logger.info(f"Getting weather forecast for coordinates: {latitude}, {longitude}")
            
            forecast_data = await get_weather_forecast(latitude, longitude)
            
            return [
                types.TextContent(
                    type="text",
                    text=json.dumps(forecast_data, indent=2)
                )
            ]
            
        elif name == "get_weather_summary":
            if not arguments:
                raise ValueError("Missing required arguments")
            
            latitude = arguments.get("latitude")
            longitude = arguments.get("longitude")
            
            if latitude is None or longitude is None:
                raise ValueError("Both latitude and longitude are required")
            
            # Validate coordinate ranges
            if not (-90 <= latitude <= 90):
                raise ValueError("Latitude must be between -90 and 90 degrees")
            if not (-180 <= longitude <= 180):
                raise ValueError("Longitude must be between -180 and 180 degrees")
            
            logger.info(f"Getting weather summary for coordinates: {latitude}, {longitude}")
            
            forecast_data = await get_weather_forecast(latitude, longitude)
            summary = format_weather_summary(forecast_data)
            
            return [
                types.TextContent(
                    type="text",
                    text=summary
                )
            ]
        else:
            raise ValueError(f"Unknown tool: {name}")
            
    except WeatherAPIError as e:
        logger.error(f"Weather API error in {name}: {e}")
        return [
            types.TextContent(
                type="text",
                text=f"Weather service error: {str(e)}"
            )
        ]
    except ValueError as e:
        logger.error(f"Validation error in {name}: {e}")
        return [
            types.TextContent(
                type="text",
                text=f"Invalid arguments: {str(e)}"
            )
        ]
    except Exception as e:
        logger.error(f"Unexpected error in {name}: {e}")
        return [
            types.TextContent(
                type="text",
                text=f"Unexpected error: {str(e)}"
            )
        ]

async def main():
    """Main entry point for the MCP weather server."""
    # Run the server using stdin/stdout streams
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="weather-mcp-server",
                server_version="1.0.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(main())
