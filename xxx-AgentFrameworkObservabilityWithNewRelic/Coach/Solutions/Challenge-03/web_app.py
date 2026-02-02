# 📦 Import Required Libraries
# Challenge 02: TODO - Base imports for Flask and Agent Framework
from dotenv import load_dotenv
import os
import asyncio
import time
import logging
from random import randint, uniform

# Flask imports
from flask import Flask, render_template, request, jsonify

# Challenge 02: TODO - Import Microsoft Agent Framework
# HINT: from agent_framework.openai import ???
# HINT: from agent_framework import ???
from agent_framework.openai import OpenAIChatClient
from agent_framework import ChatAgent


# Challenge 03: TODO - Import OpenTelemetry instrumentation
# HINT: from agent_framework.observability import ???
# HINT: from opentelemetry.sdk.resources import ???
# HINT: from opentelemetry.semconv._incubating.attributes.service_attributes import ???
from opentelemetry.sdk.resources import Resource
from opentelemetry.semconv._incubating.attributes.service_attributes import SERVICE_NAME, SERVICE_VERSION
from agent_framework.observability import configure_otel_providers, get_tracer


# Challenge 04: TODO - Import OTLP Exporters for New Relic
# HINT: from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import ???
# HINT: from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import ???
# HINT: from opentelemetry.exporter.otlp.proto.grpc._log_exporter import ???
# HINT: from opentelemetry.sdk._logs import ???


# Challenge 06: TODO - Import for AI Monitoring
# HINT: from opentelemetry._logs import ???


# Challenge 07: TODO - Import for Security Detection
# HINT: import re
# HINT: from typing import ???


# Load environment variables
load_dotenv()

# 📝 Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ============================================================================
# Challenge 03: TODO - Setup OpenTelemetry Observability
# ============================================================================
# Step 1: Create a resource identifying your service
# HINT: resource = Resource.create({ ??? })
resource = Resource.create({
    SERVICE_NAME: "travel-planner",
    SERVICE_VERSION: "0.1.0"
})

#
# Step 3: Setup observability with the resource
# HINT: configure_otel_providers()
configure_otel_providers()

#
# Challenge 04: TODO - Update to use OTLP exporters for New Relic
# HINT: configure_otel_providers(exporters=[???])

#
# Challenge 03: TODO - Step 3: Get tracer and meter instances
# HINT: tracer = ???
# ============================================================================
tracer = get_tracer()

# ============================================================================
# Challenge 05: TODO - Create Custom Metrics for Monitoring
# ============================================================================
# HINT: meter = ???
# HINT: request_counter = meter.create_counter(name="???\", description="???\", unit="???")
# HINT: error_counter = meter.create_counter(???)
# HINT: response_time_histogram = meter.create_histogram(???)
# HINT: tool_call_counter = meter.create_counter(???)

#
# Challenge 06: TODO - Add evaluation metrics
# HINT: evaluation_passed_counter = meter.create_counter(???)

#
# Challenge 07: TODO - Add security metrics
# HINT: security_detected_counter = meter.create_counter(???)
# HINT: security_blocked_counter = meter.create_counter(???)
# HINT: security_score_histogram = meter.create_histogram(???)
# ============================================================================

# 🌐 Initialize Flask Application
app = Flask(__name__)

# ============================================================================
# Challenge 02: TODO - Define Tool Functions
# ============================================================================
# These are functions the agent can call to get information


def get_random_destination() -> str:
    """
    Challenge 02: TODO - Returns a random travel destination

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)

    Returns:
        A string confirming the destination

    Hint: Simply return a confirmation message with the destination name
    """
    destination = ""
    with tracer.start_as_current_span("get_random_destination") as span:
        span.set_attribute("tool.name", "get_random_destination")
        destinations = ["Garmisch-Partenkirchen", "Munich",
                        "Paris", "New York", "Tokyo", "Sydney", "Cairo"]
        destination = destinations[randint(0, len(destinations) - 1)]
        logger.info(f"Selected random destination: {destination}")
    return f"You have selected {destination} as your travel destination."


def get_weather(location: str) -> str:
    """
    Challenge 02: TODO - Returns weather for a location

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)


    Args:
        location: The location to get weather for

    Returns:
        Weather description string
    """
    logger.info(f"Fetching weather for location: {location}")
    weather = ""
    with tracer.start_as_current_span("get_weather") as span:
        span.set_attribute("tool.name", "get_weather")
        span.set_attribute("location", location)
        weather = f"The weather in {location} is sunny with a high of {randint(20, 30)}°C."
        logger.info(f"Weather for {location}: {weather}")
    return weather


def get_datetime() -> str:
    """
    Challenge 02: TODO - Returns current date and time

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)


    Returns:
        Current date and time as string
    """
    logger.info("Fetching current date and time.")
    datetime_str = ""
    with tracer.start_as_current_span("get_datetime") as span:
        span.set_attribute("tool.name", "get_datetime")
        datetime_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        logger.info(f"Current date and time: {datetime_str}")
    return datetime_str


model_id = os.environ.get("MODEL_ID", "gpt-5-mini")

# ============================================================================
# Challenge 02: TODO - Create the OpenAI Chat Client
# ============================================================================
# HINT: use `OpenAIChatClient` with appropriate parameters, i.e. base_url, api_key, model_id
openai_chat_client = OpenAIChatClient(
    base_url=os.environ.get("MSFT_FOUNDRY_ENDPOINT"),
    api_key=os.environ.get("MSFT_FOUNDRY_API_KEY"),
    model_id=model_id
)


# ============================================================================
# Challenge 02: TODO - Create the Travel Planning ChatAgent
# ============================================================================
# HINT: use `ChatAgent` with appropriate parameters, i.e. chat_client, instructions, tools
agent = ChatAgent(
    chat_client=openai_chat_client,
    instructions="You are a helpful AI Agent that can help plan vacations for customers at random destinations.",
    # Tool functions available to the agent
    tools=[get_random_destination, get_weather, get_datetime]
)

# ============================================================================
# Challenge 07: TODO - Harden System Prompt Against Prompt Injection
# ============================================================================
# HINT: HARDENED_INSTRUCTIONS = hardenInstructions(instructions)
# HINT: use `ChatAgent` with hardened instructions

# ============================================================================
# Challenge 07: TODO - Security Detection Functions
# ============================================================================
# HINT: def detect_prompt_injection(user_input: str) -> Dict:
#     return {"risk_score": ???, "patterns_detected": ???}
#
# HINT: def sanitize_input(text: str) -> str:
#     return ???
#
# ============================================================================

# ============================================================================
# Flask Routes
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

    Challenge 02: TODO - Basic agent execution
    Challenge 03: TODO - Add span instrumentation
    Challenge 05: TODO - Record custom metrics
    Challenge 06: TODO - Emit AI Monitoring events and run evaluation
    Challenge 07: TODO - Add security detection and input sanitization
    """
    logger.info("Received travel plan request.")
    with tracer.start_as_current_span("plan_trip") as span:

        # Challenge 05: TODO - Start timing the request
        # HINT: start_time = ???

        # Challenge 03: TODO - Create span for the entire request
        # HINT: with tracer.start_as_current_span(???) as span:

        try:
            # Challenge 02: TODO - Extract form data
            date = request.form.get('date', '')
            duration = request.form.get('duration', '3')
            interests = request.form.getlist('interests')
            special_requests = request.form.get('special_requests', '')
            
            
            # Challenge 03: TODO - Set span attributes for request parameters
            # HINT: span.set_attribute(???, ???)
            span.set_attribute("date", date)
            span.set_attribute("duration", duration)
            
            # Challenge 05: TODO - Increment request counter
            # HINT: request_counter.add(???)

            # ====================================================================
            # Challenge 07: TODO - Security Detection (BEFORE agent execution)
            # ====================================================================
            # HINT: user_input = ???
            # HINT: detection_result = detect_prompt_injection(???)
            # HINT: risk_score = detection_result[???]
            # HINT: if risk_score > ???:
            #           return render_template(???, error=???), ???
            # HINT: special_requests = sanitize_input(???)
            # ====================================================================

            # Challenge 02: TODO - Build user prompt for the agent
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

            # ====================================================================
            # Challenge 06: TODO - Emit AI Monitoring Event (User Message)
            # ====================================================================
            # HINT: logger.info(???, extra={
            #     "newrelic.event.type": "LlmChatCompletionMessage",
            #     "role": ???,
            #     "content": ???,
            #     "sequence": ???
            # })
            # ====================================================================

            # Challenge 03: TODO - Create span for agent execution
            # HINT: with tracer.start_as_current_span(???) as agent_span:
            with tracer.start_as_current_span("plan_trip_request") as agent_span:

                # Challenge 02: TODO - Run the agent asynchronously
                # HINT: response = await agent.run(???)
                loop = asyncio.new_event_loop()
                asyncio.set_event_loop(loop)
                response = await agent.run(user_prompt)
                loop.close()
                
                # Challenge 02: TODO - Extract the travel plan from response
                # HINT: text_content = response.messages[???].contents[???].text
                last_message = response.messages[-1]
                text_content = last_message.contents[0].text
                
                # Challenge 03: TODO - Add response attributes to span
                # HINT: agent_span.set_attribute(???, ???)
                agent_span.set_attribute("date", date)
                agent_span.set_attribute("duration", duration)

            # ====================================================================
            # Challenge 06: TODO - Emit AI Monitoring Events (Assistant + Summary)
            # ====================================================================
            # HINT: logger.info(???, extra={"newrelic.event.type": "LlmChatCompletionMessage", ...})
            # HINT: logger.info(???, extra={"newrelic.event.type": "LlmChatCompletionSummary", ...})
            # ====================================================================

            # ====================================================================
            # Challenge 06: TODO - Run Evaluation
            # ====================================================================
            # HINT: evaluation_result = ???
            # HINT: evaluation_passed_counter.add(???)
            # ====================================================================

            # Challenge 05: TODO - Record response time
            # HINT: duration_ms = ???
            # HINT: response_time_histogram.record(???)

            return render_template('result.html',
                                travel_plan=text_content,
                                duration=duration)

        except Exception as e:
            logger.error(f"Error planning trip: {str(e)}")

            # Challenge 05: TODO - Increment error counter
            # HINT: error_counter.add(???)

            return render_template('error.html', error=str(e)), 500


# ============================================================================
# Challenge 06: TODO - User Feedback Collection Route
# ============================================================================
# HINT: @app.route('/feedback', methods=[???])
# HINT: def feedback():
#     trace_id = ???
#     rating = ???
#     logger.info(???, extra={"newrelic.event.type": "LlmFeedbackMessage", ...})
#     return jsonify(???)
# ============================================================================


# ============================================================================
# Main Execution
# ============================================================================
if __name__ == "__main__":
    # Run Flask development server
    app.run(debug=True, host='0.0.0.0', port=5002)
