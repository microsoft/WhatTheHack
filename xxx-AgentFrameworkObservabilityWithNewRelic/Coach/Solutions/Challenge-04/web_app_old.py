# 📦 Import Required Libraries
from agent_framework.observability import configure_otel_providers, get_tracer, get_meter
from agent_framework.openai import OpenAIChatClient
from agent_framework import ChatAgent
from dotenv import load_dotenv
from opentelemetry.semconv._incubating.attributes.service_attributes import SERVICE_NAME, SERVICE_VERSION
from opentelemetry._logs import set_logger_provider
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk.resources import Resource
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

import os
import asyncio
import time
import logging
from random import randint, uniform

# Flask imports
from flask import Flask, render_template, request, jsonify

import logging

# Load environment variables
load_dotenv()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Microsoft Agent Framework

# Create named logger for application logs (before getting root logger)
app_logger = logging.getLogger("travel_planner")
app_logger.setLevel(logging.INFO)

# Create a resource identifying your service
resource = Resource.create({
    SERVICE_NAME: "travel-planner",
    SERVICE_VERSION: "0.1.0"
})

# Create OTLP exporters that will auto-read endpoint and headers from environment
# (OTEL_EXPORTER_OTLP_ENDPOINT and OTEL_EXPORTER_OTLP_HEADERS)
otlp_exporters = [
    OTLPSpanExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
    OTLPMetricExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
    OTLPLogExporter(),  # Reads from OTEL_EXPORTER_OTLP_* env vars
]

# Setup observability with the resource
configure_otel_providers(resource, exporters=otlp_exporters)
# Get a tracer
tracer = get_tracer()
# Get a meter
meter = get_meter()

# 🌐 Initialize Flask Application
app = Flask(__name__)

# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
# Create a fresh logger provider with only OTLP exporter
logger_provider = LoggerProvider(resource=resource)
otlp_log_exporter = [e for e in otlp_exporters if type(
    e).__name__ == 'OTLPLogExporter'][0]
logger_provider.add_log_record_processor(
    BatchLogRecordProcessor(otlp_log_exporter))

# Get root logger to configure all loggers
root_logger = logging.getLogger()

# Remove old handlers and add new one with proper OTLP configuration
for handler in root_logger.handlers[:]:
    if isinstance(handler, LoggingHandler):
        root_logger.removeHandler(handler)

# Add new LoggingHandler to root logger (this will capture all loggers including Flask)
handler = LoggingHandler(logger_provider=logger_provider)
root_logger.addHandler(handler)
root_logger.setLevel(logging.INFO)
# set_logger_provider(logger_provider)

# Also attach to our named app logger explicitly
app_logger.addHandler(handler)

# Create a reference for backward compatibility
logger = app_logger

# ============================================================================
# TODO 1: Define Tool Functions
# ============================================================================
# These are functions the agent can call to get information


def get_random_destination() -> str:
    """
    TODO: Implement this tool function

    Args:
        destination: The destination the user selected

    Returns:
        A string confirming the destination

    Hint: Simply return a confirmation message with the destination name
    """
    # Create a span for this tool call
    with tracer.start_as_current_span("get_random_destination") as span:
        destinations = ["Garmisch-Partenkirchen", "Munich",
                        "Paris", "New York", "Tokyo", "Sydney", "Cairo"]
        destination = destinations[randint(0, len(destinations) - 1)]
        # Set attributes that will help you debug
        span.set_attribute("destination", destination)
        result = f"You have selected {destination} as your travel destination."
    logger.info(f"Selected random destination: {destination}")
    return result


def get_weather(location: str) -> str:
    """
    TODO: Implement this tool function

    This should return weather information for a location.
    For now, you can return a fake weather message.

    Args:
        location: The location to get weather for

    Returns:
        A weather description string

    Hint: For MVP, just return something like "The weather in {location} is sunny with a high of 22°C"
    Real weather API integration is optional and can use OPENWEATHER_API_KEY
    """
    # Log the request
    logger.info(f"Fetching weather for location: {location}")

    # Create a span for this tool call
    with tracer.start_as_current_span("get_weather") as span:
        # Set attributes that will help you debug
        span.set_attribute("location", location)

        try:
            # Simulate API call
            result = f"The weather in {location} is sunny with a high of {randint(0, 30)}°C."

            # Log success with context
            logger.info(f"Weather retrieved", extra={
                "location": location,
                "result": result
            })

            # Add success info
            span.set_attribute("weather_retrieved", True)
        except Exception as e:
            # Log error with context
            logger.error(f"Weather API failed", extra={
                "location": location,
                "error": str(e)
            })
            raise

    return result


def get_datetime() -> str:
    """
    TODO: Implement this tool function

    Return the current date and time

    Returns:
        Current date and time as string

    Hint: Use datetime.datetime.now().isoformat()
    """
    logger.info("Fetching current date and time.")
    # Create a span for this tool call
    with tracer.start_as_current_span("get_datetime") as span:
        result = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        # Set attributes that will help you debug
        span.set_attribute("planCreatedDateTime", result)
    return result

# ============================================================================
# TODO 2: Create the OpenAI Chat Client
# ============================================================================


model_id = os.environ.get("MODEL_ID", "gpt-5-mini")

# Use Microsoft Foundry endpoint directly
openai_chat_client = OpenAIChatClient(
    base_url=os.environ.get("MSFT_FOUNDRY_ENDPOINT"),
    api_key=os.environ.get("MSFT_FOUNDRY_API_KEY"),
    model_id=model_id
)


# ============================================================================
# TODO 3: Create the Travel Planning Agent
# ============================================================================

# TODO: Create a ChatAgent with:
# - chat_client: Your OpenAI client
# - instructions: "You are a helpful AI Agent that can help plan vacations for customers."
# - tools: A list of the three tool functions [get_random_destination, get_weather, get_datetime]

agent = ChatAgent(
    chat_client=openai_chat_client,
    instructions="You are a helpful AI Agent that can help plan vacations for customers at random destinations.",
    # Tool functions available to the agent
    tools=[get_random_destination, get_weather, get_datetime]
)

# ============================================================================
# TODO 4: Create Flask Routes
# ============================================================================


@app.route('/')
def index():
    """Serve the home page with the travel planning form."""
    logger.info("Serving home page.")
    return render_template('index.html')


@app.route('/plan', methods=['POST'])
async def plan_trip():
    """
    Handle travel plan requests from the form.

    TODO: Implement this endpoint
    """
    logger.info("Received travel plan request.")
    # Create a span for this tool call
    with tracer.start_as_current_span("plan_trip") as span:
        try:
            # TODO: Extract form data
            # Hint: Use request.form.get() for single values and request.form.getlist() for checkboxes
            # You need: origin, destination, date, duration, interests (list), special_requests
            date = request.form.get('date', '')
            duration = request.form.get('duration', '3')
            interests = request.form.getlist('interests')
            special_requests = request.form.get('special_requests', '')

            # TODO: Build a user prompt for the agent
            # Example structure:
            # f"Plan me a {duration}-day trip to a random destination starting on {date} ..."
            user_prompt = f"""Plan me a {duration}-day trip to a random destination starting on {date}.

                Trip Details:
                - Date: {date}
                - Duration: {duration} days
                - Interests: {', '.join(interests) if interests else 'General sightseeing'}
                - Special Requests: {special_requests if special_requests else 'None'}

                Instructions:
                1. A detailed day-by-day itinerary with activities tailored to the interests
                2. Current weather information for the destination
                3. Local cuisine recommendations
                4. Best times to visit specific attractions
                5. Travel tips and budget estimates
                6. Current date and time reference
                """

            with tracer.start_as_current_span("plan_trip_request") as span:
                span.set_attribute("date", date)
                span.set_attribute("duration", duration)
                # TODO: Run the agent asynchronously
                # Hint: Use asyncio to run: response = await agent.run(user_prompt)
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
                response = await agent.run(user_prompt)
                loop.close()

                # TODO: Extract the travel plan from response
                # Hint: response.messages[-1].contents[0].text
                last_message = response.messages[-1]
                text_content = last_message.contents[0].text

                # Add response attributes
                span.set_attribute("response.token_count",
                                   response.usage_details.input_token_count +
                                   response.usage_details.output_token_count)

            # TODO: Render and return 'result.html' with the travel plan
            return render_template('result.html',
                                   travel_plan=text_content,
                                   duration=duration)

        except Exception as e:
            logger.error(f"Error planning trip: {str(e)}")
            return render_template('error.html', error=str(e)), 500

# ============================================================================
# Main Execution
# ============================================================================

if __name__ == "__main__":
    # Run Flask development server
    app.run(debug=True, host='0.0.0.0', port=5002)
