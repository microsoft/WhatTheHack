"""
Assistant Tools for Weather Integration using MCP

This module provides weather tools for the Veta assistant using the MCP weather server.
These tools are integrated into the existing Contoso AI Apps Backend architecture.
"""

import json
import logging
import os
from typing import Dict, Any
from shared.mcp_weather_client import SyncMCPWeatherClient, MCPClientError

# Configure logging
logger = logging.getLogger(__name__)

# Global MCP client instance
_mcp_client: SyncMCPWeatherClient = None

def _get_mcp_client() -> SyncMCPWeatherClient:
    """Get or create the MCP weather client instance"""
    global _mcp_client
    
    if _mcp_client is None:
        # Get the path to the MCP weather server script
        current_dir = os.path.dirname(os.path.abspath(__file__))
        backend_dir = os.path.dirname(current_dir)
        server_script_path = os.path.join(backend_dir, "mcp_weather_server.py")
        
        _mcp_client = SyncMCPWeatherClient(server_script_path)
    
    return _mcp_client

def v_get_weather_forecast(latitude: str, longitude: str) -> str:
    """
    Get weather forecast for the specified coordinates using the MCP weather server.
    
    This tool is designed for the Veta assistant to check weather conditions
    before making yacht reservations for clients.
    
    Args:
        latitude: Latitude coordinate as string (e.g., "40.7128")
        longitude: Longitude coordinate as string (e.g., "-74.0060")
        
    Returns:
        JSON string containing weather forecast data
    """
    try:
        # Validate and convert coordinates
        try:
            lat = float(latitude)
            lon = float(longitude)
        except (ValueError, TypeError) as e:
            error_msg = f"Invalid coordinates provided. Latitude: {latitude}, Longitude: {longitude}. Error: {str(e)}"
            logger.error(error_msg)
            return json.dumps({
                "error": "Invalid coordinates",
                "message": error_msg,
                "success": False
            })
        
        # Validate coordinate ranges
        if not (-90 <= lat <= 90):
            error_msg = f"Latitude {lat} is out of range. Must be between -90 and 90 degrees."
            logger.error(error_msg)
            return json.dumps({
                "error": "Invalid latitude",
                "message": error_msg,
                "success": False
            })
        
        if not (-180 <= lon <= 180):
            error_msg = f"Longitude {lon} is out of range. Must be between -180 and 180 degrees."
            logger.error(error_msg)
            return json.dumps({
                "error": "Invalid longitude", 
                "message": error_msg,
                "success": False
            })
        
        logger.info(f"Getting weather forecast for coordinates: {lat}, {lon}")
        
        # Get MCP client and fetch weather data
        client = _get_mcp_client()
        forecast_data = client.get_weather_forecast(lat, lon)
        
        # Add success indicator and metadata
        result = {
            "success": True,
            "coordinates": {
                "latitude": lat,
                "longitude": lon
            },
            "forecast": forecast_data,
            "source": "National Weather Service",
            "provider": "MCP Weather Server"
        }
        
        logger.info(f"Successfully retrieved weather forecast for {lat}, {lon}")
        return json.dumps(result, indent=2)
        
    except MCPClientError as e:
        error_msg = f"Weather service error: {str(e)}"
        logger.error(error_msg)
        return json.dumps({
            "error": "Weather service unavailable",
            "message": error_msg,
            "success": False
        })
    
    except Exception as e:
        error_msg = f"Unexpected error getting weather forecast: {str(e)}"
        logger.error(error_msg)
        return json.dumps({
            "error": "Internal error",
            "message": error_msg,
            "success": False
        })

def v_get_weather_summary_for_client(latitude: str, longitude: str) -> str:
    """
    Get a formatted weather summary suitable for presenting to yacht tour clients.
    
    This tool provides a client-friendly weather summary that Veta can use
    to inform customers about weather conditions before confirming yacht reservations.
    
    Args:
        latitude: Latitude coordinate as string (e.g., "40.7128")
        longitude: Longitude coordinate as string (e.g., "-74.0060")
        
    Returns:
        Formatted weather summary string suitable for client presentation
    """
    try:
        # Validate and convert coordinates
        try:
            lat = float(latitude)
            lon = float(longitude)
        except (ValueError, TypeError) as e:
            error_msg = f"Invalid coordinates provided. Latitude: {latitude}, Longitude: {longitude}. Error: {str(e)}"
            logger.error(error_msg)
            return f"❌ Unable to get weather information: Invalid coordinates provided ({latitude}, {longitude})"
        
        # Validate coordinate ranges
        if not (-90 <= lat <= 90):
            return f"❌ Unable to get weather information: Invalid latitude {lat} (must be between -90 and 90 degrees)"
        
        if not (-180 <= lon <= 180):
            return f"❌ Unable to get weather information: Invalid longitude {lon} (must be between -180 and 180 degrees)"
        
        logger.info(f"Getting weather summary for client at coordinates: {lat}, {lon}")
        
        # Get MCP client and fetch weather summary
        client = _get_mcp_client()
        weather_summary = client.get_weather_summary(lat, lon)
        
        # Add header with coordinate information
        client_summary = f"🌊 Weather Information for Your Yacht Tour Location 🌊\n"
        client_summary += f"📍 Coordinates: {lat:.4f}, {lon:.4f}\n\n"
        client_summary += weather_summary
        client_summary += f"\n📡 Data provided by the National Weather Service"
        
        logger.info(f"Successfully retrieved weather summary for client at {lat}, {lon}")
        return client_summary
        
    except MCPClientError as e:
        error_msg = f"Weather service error: {str(e)}"
        logger.error(error_msg)
        return f"❌ Weather information temporarily unavailable: {error_msg}\n\nPlease try again in a few moments, or contact our support team for assistance."
    
    except Exception as e:
        error_msg = f"Unexpected error getting weather summary: {str(e)}"
        logger.error(error_msg)
        return f"❌ Unable to retrieve weather information due to an unexpected error.\n\nPlease contact our support team for assistance."

def v_check_weather_suitable_for_yacht_tour(latitude: str, longitude: str, 
                                           min_temperature: str = "60",
                                           max_wind_speed: str = "25") -> str:
    """
    Check if weather conditions are suitable for a yacht tour.
    
    This tool evaluates weather conditions against predefined criteria
    to help Veta determine if conditions are suitable for yacht tours.
    
    Args:
        latitude: Latitude coordinate as string
        longitude: Longitude coordinate as string  
        min_temperature: Minimum acceptable temperature in Fahrenheit (default: "60")
        max_wind_speed: Maximum acceptable wind speed in mph (default: "25")
        
    Returns:
        JSON string with suitability assessment and recommendations
    """
    try:
        # Validate and convert coordinates
        try:
            lat = float(latitude)
            lon = float(longitude)
            min_temp = float(min_temperature)
            max_wind = float(max_wind_speed)
        except (ValueError, TypeError) as e:
            error_msg = f"Invalid parameters provided. Error: {str(e)}"
            logger.error(error_msg)
            return json.dumps({
                "suitable": False,
                "reason": "Invalid parameters",
                "message": error_msg,
                "success": False
            })
        
        logger.info(f"Checking weather suitability for yacht tour at {lat}, {lon}")
        
        # Get weather forecast
        client = _get_mcp_client()
        forecast_data = client.get_weather_forecast(lat, lon)
        
        # Analyze first few periods for suitability
        periods = forecast_data.get("periods", [])
        if not periods:
            return json.dumps({
                "suitable": False,
                "reason": "No weather data available",
                "success": False
            })
        
        # Check current and next period (today and tonight/tomorrow)
        analysis_periods = periods[:2]
        
        issues = []
        warnings = []
        
        for period in analysis_periods:
            period_name = period.get("name", "Unknown")
            temperature = period.get("temperature", 0)
            short_forecast = period.get("shortForecast", "").lower()
            detailed_forecast = period.get("detailedForecast", "").lower()
            
            # Temperature check
            if temperature < min_temp:
                issues.append(f"{period_name}: Temperature too low ({temperature}°F, minimum {min_temp}°F)")
            
            # Weather condition checks
            dangerous_conditions = ["thunderstorm", "severe", "tornado", "hurricane", "gale"]
            concerning_conditions = ["rain", "storm", "showers", "snow", "fog"]
            
            for condition in dangerous_conditions:
                if condition in short_forecast or condition in detailed_forecast:
                    issues.append(f"{period_name}: Dangerous weather conditions ({condition})")
            
            for condition in concerning_conditions:
                if condition in short_forecast or condition in detailed_forecast:
                    warnings.append(f"{period_name}: Weather may affect tour comfort ({condition})")
        
        # Determine overall suitability
        suitable = len(issues) == 0
        
        result = {
            "suitable": suitable,
            "coordinates": {"latitude": lat, "longitude": lon},
            "criteria": {
                "min_temperature_f": min_temp,
                "max_wind_speed_mph": max_wind
            },
            "issues": issues,
            "warnings": warnings,
            "recommendation": "",
            "periods_analyzed": len(analysis_periods),
            "success": True
        }
        
        # Generate recommendations
        if suitable:
            if warnings:
                result["recommendation"] = "Weather is suitable for yacht tours, but inform clients about minor conditions noted in warnings."
            else:
                result["recommendation"] = "Excellent weather conditions for yacht tours!"
        else:
            result["recommendation"] = "Weather conditions are not recommended for yacht tours. Consider rescheduling or offering alternative dates."
        
        logger.info(f"Weather suitability check complete: {'Suitable' if suitable else 'Not suitable'}")
        return json.dumps(result, indent=2)
        
    except MCPClientError as e:
        error_msg = f"Weather service error: {str(e)}"
        logger.error(error_msg)
        return json.dumps({
            "suitable": False,
            "reason": "Weather service unavailable",
            "message": error_msg,
            "success": False
        })
    
    except Exception as e:
        error_msg = f"Unexpected error checking weather suitability: {str(e)}"
        logger.error(error_msg)
        return json.dumps({
            "suitable": False,
            "reason": "Internal error",
            "message": error_msg,
            "success": False
        })

# Contoso Islands coordinates for quick reference
CONTOSO_ISLANDS_COORDINATES = {
    "main_island": {"latitude": "25.7617", "longitude": "-80.1918"},  # Miami area as example
    "north_bay": {"latitude": "25.8000", "longitude": "-80.1500"},
    "south_harbor": {"latitude": "25.7200", "longitude": "-80.2300"},
    "east_marina": {"latitude": "25.7700", "longitude": "-80.1300"},
    "west_dock": {"latitude": "25.7500", "longitude": "-80.2500"}
}

def v_get_contoso_islands_weather() -> str:
    """
    Get weather information for all Contoso Islands locations.
    
    This is a convenience tool that checks weather for all major Contoso Islands
    yacht tour departure points.
    
    Returns:
        Comprehensive weather summary for all Contoso Islands locations
    """
    try:
        logger.info("Getting weather for all Contoso Islands locations")
        
        client = _get_mcp_client()
        results = []
        
        for location_name, coords in CONTOSO_ISLANDS_COORDINATES.items():
            try:
                lat = float(coords["latitude"])
                lon = float(coords["longitude"])
                
                summary = client.get_weather_summary(lat, lon)
                
                results.append(f"=== {location_name.replace('_', ' ').title()} ===")
                results.append(f"📍 {lat}, {lon}")
                results.append(summary)
                results.append("")
                
            except Exception as e:
                logger.warning(f"Failed to get weather for {location_name}: {e}")
                results.append(f"=== {location_name.replace('_', ' ').title()} ===")
                results.append(f"❌ Weather data unavailable: {str(e)}")
                results.append("")
        
        final_summary = "🏝️ Contoso Islands Weather Report 🏝️\n\n"
        final_summary += "\n".join(results)
        final_summary += "📡 All data provided by the National Weather Service via MCP Weather Server"
        
        logger.info("Successfully retrieved weather for all Contoso Islands locations")
        return final_summary
        
    except Exception as e:
        error_msg = f"Error getting Contoso Islands weather: {str(e)}"
        logger.error(error_msg)
        return f"❌ Unable to retrieve Contoso Islands weather information: {error_msg}"
