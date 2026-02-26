# 📦 Import Required Libraries
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

# Challenge 03: TODO - Import OpenTelemetry instrumentation
# HINT: from agent_framework.observability import ???
# HINT: from opentelemetry.sdk.resources import ???
# HINT: from opentelemetry.semconv._incubating.attributes.service_attributes import ???


# Challenge 04: TODO - Import OTLP Exporters for New Relic
# HINT: from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import ???
# HINT: from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import ???
# HINT: from opentelemetry.exporter.otlp.proto.grpc._log_exporter import ???
# HINT: from opentelemetry.sdk._logs import ???


# Challenge 06: TODO - Import for AI Monitoring
# HINT: from opentelemetry._logs import ???


# Challenge 08: TODO - Import for Security Detection
# HINT: import re
# HINT: from typing import ???


# Load environment variables
load_dotenv()

# ============================================================================
# Challenge 03: TODO - Setup OpenTelemetry Observability
# ============================================================================
# Step 1: Create a resource identifying your service
# HINT: resource = Resource.create({ ??? })

#
# Step 3: Setup observability with the resource
# HINT: https://learn.microsoft.com/en-us/agent-framework/user-guide/observability?pivots=programming-language-python#1-standard-opentelemetry-environment-variables-recommended

#
# Challenge 04: TODO - Update to use OTLP exporters for New Relic
# HINT: configure_otel_providers(exporters=[???])

#
# Challenge 03: TODO - Step 3: Get tracer and meter instances
# HINT: tracer = ???
# HINT: meter = ???
# ============================================================================

# 📝 Configure Logging
logger = logging.getLogger("agent_framework.web_app")
logger.setLevel(logging.INFO)
logger.propagate = True


# ============================================================================
# Challenge 05: TODO - Create Custom Metrics for Monitoring
# ============================================================================
# HINT: request_counter = meter.create_counter(name="???\", description="???\", unit="???")
# HINT: error_counter = meter.create_counter(???)
# HINT: tool_call_counter = meter.create_counter(???)

#
# Challenge 06: TODO - Add evaluation metrics
# HINT: evaluation_passed_counter = meter.create_counter(???)

#
# Challenge 08: TODO - Add security metrics
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
    Challenge 02: TODO - (optional) Update function to return a random travel destination

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)

    Returns:
        A string confirming the destination

    Hint: Simply return a confirmation message with the destination name
    """

    # Simulate network latency with a small random sleep
    delay_seconds = uniform(0, 0.99)
    time.sleep(delay_seconds)

    destinations = ["Garmisch-Partenkirchen", "Munich",
                    "Paris", "New York", "Tokyo", "Sydney", "Cairo"]
    destination = destinations[randint(0, len(destinations) - 1)]
    logger.info(f"Selected random destination: {destination}")

    # Challenge 05: TODO - Increment request counter
    # HINT: request_counter.add(???)

    # Challenge 05: TODO - Increment tool call counter
    # HINT: tool_call_counter.add(???)

    return f"You have selected {destination} as your travel destination."


def get_weather(location: str) -> str:
    """
    Challenge 02: TODO - Update function to return weather for a location

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)


    Args:
        location: The location to get weather for

    Returns:
        Weather description string
    """

    # Simulate network latency with a small random float sleep
    delay_seconds = uniform(0.3, 3.7)
    time.sleep(delay_seconds)

    # fail every now and then to simulate real-world API unreliability
    if randint(1, 10) > 7:
        raise Exception(
            "Weather service is currently unavailable. Please try again later.")

    logger.info(f"Fetching weather for location: {location}")

    # Challenge 05: TODO - Increment tool call counter
    # HINT: tool_call_counter.add(???)

    pass  # Your code here


def get_datetime() -> str:
    """
    Challenge 02: TODO - (optional) Update function to return current date and time

    Challenge 03: TODO - Add OpenTelemetry span instrumentation
    HINT: with tracer.start_as_current_span(???) as span:
    HINT:     span.set_attribute(???, ???)


    Returns:
        Current date and time as string
    """

    # Simulate network latency with a small random float sleep
    delay_seconds = uniform(0.10, 5.0)
    time.sleep(delay_seconds)

    logger.info("Fetching current date and time.")

    # Challenge 05: TODO - Increment tool call counter
    # HINT: tool_call_counter.add(???)

    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())


model_id = os.environ.get("MODEL_ID", "gpt-5-mini")

# ============================================================================
# Challenge 02: TODO - Create the OpenAI Chat Client
# ============================================================================
# HINT: use `OpenAIChatClient` with appropriate parameters, i.e. base_url, api_key, model_id


# ============================================================================
# Challenge 02: TODO - Create the Travel Planning Agent
# ============================================================================
# HINT: use `openai_chat_client.as_agent(...)` with appropriate parameters, i.e. chat_client, instructions, tools


# ============================================================================
# Challenge 08: TODO - Harden System Prompt Against Prompt Injection
# ============================================================================
# HINT: HARDENED_INSTRUCTIONS = hardenInstructions(instructions)
# HINT: use `openai_chat_client.as_agent(...)` with hardened instructions

# ============================================================================
# Challenge 08: TODO - Security Detection Functions
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
    Challenge 08: TODO - Add security detection and input sanitization
    """
    logger.info("Received travel plan request.")

    # Challenge 05: TODO - Start timing the request
    # HINT: start_time = ???

    # Challenge 03: TODO - Create span for the entire request
    # HINT: with tracer.start_as_current_span(???) as span:

    try:
        # Extract form data
        date = request.form.get('date', '')
        duration = request.form.get('duration', '3')
        interests = request.form.getlist('interests')
        special_requests = request.form.get('special_requests', '')

        # Challenge 03: TODO - Set span attributes for request parameters
        # HINT: span.set_attribute(???, ???)

        # ====================================================================
        # Challenge 08: TODO - Security Detection (BEFORE agent execution)
        # ====================================================================
        # HINT: user_input = ???
        # HINT: detection_result = detect_prompt_injection(???)
        # HINT: risk_score = detection_result[???]
        # HINT: if risk_score > ???:
        #           return render_template(???, error=???), ???
        # HINT: special_requests = sanitize_input(???)
        # ====================================================================

        # Challenge 02: TODO - (optional) update user prompt for the agent
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

        # Challenge 02: TODO - Run the agent asynchronously
        # HINT: response = await agent.run(???)

        # Challenge 02: TODO - Extract the travel plan from response
        # HINT: text_content = response.messages[???].contents[???].text

        # Challenge 03: TODO - Add response attributes to span
        # HINT: agent_span.set_attribute(???, ???)

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

        # Render result
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
