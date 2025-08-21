# MCP Weather Integration for Contoso AI Apps Backend

This document describes the Model Context Protocol (MCP) weather integration that has been added to the Contoso AI Apps Backend to provide weather forecasting capabilities for yacht tour reservations.

## Overview

The MCP weather integration consists of three main components:

1. **MCP Weather Server** (`mcp_weather_server.py`) - A standalone MCP server that integrates with the National Weather Service API
2. **MCP Weather Client** (`shared/mcp_weather_client.py`) - A client library for communicating with the MCP server
3. **Weather Tools** (`shared/assistant_tools_weather.py`) - Assistant tools that integrate weather functionality into the existing Azure Functions backend

## Architecture

```
Azure Functions Backend (Veta Assistant)
    ↓ calls weather tools
Weather Tools (assistant_tools_weather.py)
    ↓ uses MCP client
MCP Weather Client (mcp_weather_client.py)
    ↓ communicates via JSON-RPC over stdio
MCP Weather Server (mcp_weather_server.py)
    ↓ makes HTTP requests
National Weather Service API (api.weather.gov)
```

## Key Features

### MCP Server Capabilities
- **Tool Discovery**: Automatically exposes available weather tools
- **Standardized Communication**: Uses JSON-RPC over stdio for reliable communication
- **Error Handling**: Comprehensive error handling for API failures and invalid inputs
- **Coordinate Validation**: Validates latitude/longitude ranges
- **Structured Responses**: Returns both raw data and formatted summaries

### Weather Tools for Veta Assistant
1. `get_weather_forecast` - Get detailed forecast data as JSON
2. `get_weather_summary_for_client` - Get client-friendly formatted summary
3. `check_weather_suitable_for_yacht_tour` - Assess weather suitability with criteria
4. `get_contoso_islands_weather` - Get weather for all tour locations

### Integration with Yacht Reservations
- **Mandatory Weather Checks**: Veta must check weather before confirming reservations
- **Client Communication**: Weather information is presented in a client-friendly format
- **Decision Support**: Provides suitability assessments to help clients make informed decisions

## Usage Workflow

### For Yacht Reservations (Veta Assistant)
1. Customer requests yacht reservation
2. Veta checks yacht availability and pricing
3. **Weather Check**: Veta uses weather tools to check conditions
4. Veta presents weather information to client
5. Client confirms they're comfortable with conditions
6. Reservation is created

### Contoso Islands Coordinates
The system includes predefined coordinates for major tour locations:
- **Main Island**: 25.7617, -80.1918
- **North Bay**: 25.8000, -80.1500
- **South Harbor**: 25.7200, -80.2300
- **East Marina**: 25.7700, -80.1300
- **West Dock**: 25.7500, -80.2500

## Technical Implementation

### Dependencies Added
```python
# New dependencies in requirements.txt
mcp == 1.3.0
httpx == 0.28.1
```

### Tool Registration
Weather tools are registered in `controllers/ask_veta.py`:
```python
from shared.assistant_tools_weather import (
    v_get_weather_forecast,
    v_get_weather_summary_for_client,
    v_check_weather_suitable_for_yacht_tour,
    v_get_contoso_islands_weather
)

# Tool mappings
util.register_tool_mapping("get_weather_forecast", v_get_weather_forecast)
util.register_tool_mapping("get_weather_summary_for_client", v_get_weather_summary_for_client)
util.register_tool_mapping("check_weather_suitable_for_yacht_tour", v_check_weather_suitable_for_yacht_tour)
util.register_tool_mapping("get_contoso_islands_weather", v_get_contoso_islands_weather)
```

### Tool Definitions
Weather tools are defined in `assistant_configurations/veta.json` with proper JSON Schema validation.

### System Message Updates
The agent system message (`assistant_configurations/veta.txt`) has been updated with:
- Weather checking requirements
- Workflow instructions
- Contoso Islands coordinates
- Client communication guidelines

## Security and Reliability

### Error Handling
- Comprehensive exception handling for API failures
- Graceful degradation when weather service is unavailable
- Input validation for coordinates and parameters
- User-friendly error messages

### Rate Limiting and Performance
- HTTP client with reasonable timeouts (30 seconds)
- Connection pooling via httpx `AsyncClient`
- Process lifecycle management for MCP server
- Resource cleanup on client close

### Data Sources
- **Primary**: National Weather Service (api.weather.gov)
- **Coverage**: United States and territories
- **Reliability**: Government-operated, high availability
- **Data Quality**: Official meteorological data

## Testing

Run the integration test:
```bash
cd /workspaces/wth-aiapps-codespace/ContosoAIAppsBackend
python test_weather_integration.py
```

## Benefits of MCP Architecture

### Compared to Direct API Integration
- **Standardized Discovery**: Tools are automatically discovered
- **Protocol-based Communication**: Reliable JSON-RPC communication
- **Server Introspection**: Capabilities can be queried dynamically
- **Easier Integration**: Standard MCP client patterns
- **Better Error Handling**: Protocol-level error handling
- **Future Extensibility**: Easy to add more weather tools

### Development Benefits
- **Separation of Concerns**: Weather logic isolated in MCP server
- **Testable**: Each component can be tested independently
- **Maintainability**: Clear interfaces between components
- **Reusable**: MCP server can be used by other applications

## Future Enhancements

Potential improvements:
1. **Caching**: Add weather data caching to reduce API calls
2. **More Locations**: Support international weather services
3. **Advanced Criteria**: More sophisticated suitability algorithms
4. **Historical Data**: Integration with weather history services
5. **Alerts**: Weather warning and alert notifications
6. **Marine Conditions**: Sea state and marine weather data

## Troubleshooting

### Common Issues
1. **MCP Server Won't Start**: Check Python environment and dependencies
2. **API Rate Limits**: National Weather Service has rate limits
3. **Coordinate Errors**: Ensure coordinates are within valid ranges
4. **Network Issues**: Check internet connectivity for API access

### Debugging
1. Check logs in Azure Functions
2. Test MCP server independently
3. Verify tool registrations in controller
4. Test with known good coordinates

## Integration Status

✅ **Complete Features:**
- MCP weather server implementation
- MCP client library
- Weather tools for Veta assistant
- Tool registration and configuration
- System message updates
- Comprehensive error handling
- Integration testing

✅ **Verified Components:**
- All imports working correctly
- Tool definitions in JSON configuration
- System message with weather requirements
- Proper coordinate validation
- Error handling and fall backs

The MCP weather integration is now fully implemented and ready for use with the Contoso AI Apps Backend.
