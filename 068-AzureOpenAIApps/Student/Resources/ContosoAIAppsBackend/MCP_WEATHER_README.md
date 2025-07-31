# MCP Weather Integration for Contoso AI Apps Backend

This document describes the Model Context Protocol (MCP) weather integration added to the Contoso AI Apps Backend for enhanced yacht tour booking with weather awareness.

## Overview

The MCP weather integration consists of:

1. **MCP Weather Server** (`mcp_weather_server.py`) - A standalone MCP server that interfaces with the National Weather Service API
2. **MCP Client** (`shared/mcp_weather_client.py`) - Client interface for communicating with the MCP server
3. **Assistant Tools** (`shared/assistant_tools_weather.py`) - Weather tools integrated into the Veta assistant
4. **Enhanced Veta Assistant** - Updated to check weather before making yacht reservations

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Veta Assistant │───▶│  MCP Client     │───▶│  MCP Server     │
│  (ask_veta.py)  │    │  (sync wrapper) │    │  (weather API)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
                                               ┌─────────────────┐
                                               │ National Weather│
                                               │ Service API     │
                                               └─────────────────┘
```

## Features

### Weather Tools Available to Veta

1. **`get_weather_forecast`** - Get detailed weather forecast data
2. **`get_weather_summary_for_client`** - Get client-friendly weather summary
3. **`check_weather_suitable_for_yacht_tour`** - Assess weather suitability for yacht tours
4. **`get_contoso_islands_weather`** - Get weather for all Contoso Islands locations

### Key Benefits

- **Standardized Protocol**: Uses MCP for tool discovery and communication
- **Server Introspection**: Tools are dynamically discoverable
- **Weather-Aware Booking**: Veta now checks weather before confirming reservations
- **Client Safety**: Customers are informed about weather conditions
- **Flexible Architecture**: Easy to extend with additional weather features

## Installation

### Dependencies

The following packages have been added to `requirements.txt`:

```
mcp == 1.3.0
httpx == 0.28.1
```

### Installation Steps

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Verify installation:
   ```bash
   python test_mcp_weather.py
   ```

## Configuration

### Contoso Islands Coordinates

The system includes predefined coordinates for Contoso Islands tour locations:

- **Main Island**: 25.7617, -80.1918
- **North Bay**: 25.8000, -80.1500
- **South Harbor**: 25.7200, -80.2300
- **East Marina**: 25.7700, -80.1300
- **West Dock**: 25.7500, -80.2500

### Weather Suitability Criteria

Default criteria for yacht tour suitability:
- **Minimum Temperature**: 60°F
- **Maximum Wind Speed**: 25 mph
- **Dangerous Conditions**: Thunderstorms, severe weather, hurricanes
- **Warning Conditions**: Rain, storms, fog (tour possible but with caution)

## Usage

### Veta Assistant Workflow

1. Customer requests yacht reservation
2. Veta checks yacht availability and pricing
3. **NEW**: Veta checks weather conditions for the tour location
4. **NEW**: Veta presents weather information to customer
5. **NEW**: Veta asks customer to confirm they're comfortable with weather
6. Veta proceeds with reservation only after weather confirmation

### Example Interaction

```
Customer: "I'd like to book yacht 200 for next Friday"
Veta: "Let me check availability and weather conditions..."
Veta: "Great! Yacht 200 is available for $800. Let me check the weather..."
Veta: "🌊 Weather Information for Your Yacht Tour Location 🌊
      Friday: Temperature 72°F, Partly Cloudy
      Conditions look excellent for yacht touring!
      Would you be comfortable proceeding with this weather forecast?"
Customer: "Yes, that sounds perfect!"
Veta: "Excellent! I'll proceed with your reservation..."
```

## Testing

### Manual Testing

Run the test script to verify MCP integration:

```bash
python test_mcp_weather.py
```

### Integration Testing

Test through the Veta assistant by:
1. Making a yacht reservation request
2. Observing weather check behavior
3. Verifying weather information is presented to customer

## File Structure

```
ContosoAIAppsBackend/
├── mcp_weather_server.py              # MCP weather server
├── test_mcp_weather.py               # Test script
├── controllers/
│   └── ask_veta.py                   # Updated Veta controller
├── shared/
│   ├── mcp_weather_client.py         # MCP client
│   └── assistant_tools_weather.py    # Weather tools
└── assistant_configurations/
    ├── veta.json                     # Updated tool definitions
    └── veta.txt                      # Updated system message
```

## Security Considerations

- **No API Keys Required**: Uses free National Weather Service API
- **Input Validation**: Coordinates are validated for safety
- **Error Handling**: Graceful degradation when weather service unavailable
- **Process Isolation**: MCP server runs in separate process

## Troubleshooting

### Common Issues

1. **MCP Server Won't Start**
   - Check Python path and dependencies
   - Verify mcp package installation
   - Check for port conflicts

2. **Weather Data Unavailable**
   - National Weather Service API may be down
   - Check internet connectivity
   - Verify coordinates are within US coverage

3. **Tool Registration Errors**
   - Ensure all weather tools are imported
   - Check tool name consistency
   - Verify JSON configuration syntax

### Debug Commands

```bash
# Test MCP server directly
python mcp_weather_server.py

# Test weather tools
python -c "from shared.assistant_tools_weather import v_get_weather_forecast; print(v_get_weather_forecast('25.7617', '-80.1918'))"

# Check configuration
python -c "from application_settings import ApplicationSettings; settings = ApplicationSettings(); print(settings.get_assistant_config('veta')['tools'][-1])"
```

## Future Enhancements

Potential improvements:
- **Multiple Weather Sources**: Add backup weather APIs
- **Historical Weather**: Include historical weather patterns
- **Marine Forecasts**: Integrate marine-specific weather data
- **Push Notifications**: Alert customers of weather changes
- **Weather Preferences**: Allow customers to set weather comfort levels

## Support

For issues related to MCP weather integration:
1. Check the test script output
2. Review application logs
3. Verify weather service connectivity
4. Check tool registration in Veta configuration
