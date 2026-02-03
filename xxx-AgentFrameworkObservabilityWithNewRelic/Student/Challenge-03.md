# Challenge 03 - Add OpenTelemetry Instrumentation

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Now that you have a working MVP, it's time to add observability to your WanderAI agents using [OpenTelemetry](https://opentelemetry.io/). Right now, if something goes wrong with your agent, you have no visibility into which tool was called, how long operations take, or how to correlate logs to specific requests.

OpenTelemetry is the industry standard for observability in modern applications. By instrumenting your application, you'll be able to see traces showing the full journey of each request, capture timing information, and add structured context to your logs.

Microsoft Agent Framework already integrates with OpenTelemetry out of the box, and more specifically Agent Framework emits traces, logs, and metrics according to the [OpenTelemetry GenAI Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/gen-ai/).

In this challenge, you will enhance your travel planning application by adding OpenTelemetry instrumentation to key parts of the codebase, including:

- Tool functions
- Flask route handlers
- Logging configuration

We will start by initializing OpenTelemetry in the application, then proceed to instrument the tool functions and Flask routes to capture detailed traces. Finally, we will configure structured logging that includes trace context for better correlation.

## Description

Your goal is to add comprehensive OpenTelemetry instrumentation to your travel planning application. This includes:

- **Initialize OpenTelemetry** - Set up the tracer provider and configure resource attributes to identify your service
- **Instrument Tool Functions** - Wrap each tool function with a span to capture timing and attributes
- **Instrument Flask Routes** - Add spans to your request handlers to track the full request lifecycle
- **Add Structured Logging** - Configure logging with context that correlates to your traces

### What You're Adding

**OpenTelemetry Initialization:**

- Create a resource identifying your service (e.g., "travel-planner")
- Set up the observability framework using the Agent Framework's built-in helpers

Refer to the [Agent Framework Observability Guide](https://learn.microsoft.com/en-us/agent-framework/user-guide/observability?pivots=programming-language-python) for details on initialization. It is recommended to start the simplest approach first, such as console exporter.

Once you updated your application to successfully emit traces to the **console** (hint: this should only include adding two lines of code to your app), start your app again and evaluate the console output.

Run the Flask app with the `run.sh` command. Then submit a travel request through the web UI. You should see traces being printed in the console output.

If you are curious, Agent Framework also allows you to configure logging of sensitive data (prompts, responses, function call arguments, and results). This will log sensitive data to the console along with the traces. Be cautious when enabling this in production environments.

If you see traces and logs being emitted there, you can then proceed to instrument the tool functions and Flask routes as described below.

**Tool Instrumentation:**

By leveraging the above approach you will notice that the Agent Framework automatically instruments tool calls. However, to get more detailed insights, you will manually add spans around each tool function:

- Get a tracer for creating spans
- Wrap each tool function (`get_random_destination`, `get_weather`, `get_datetime`) with `tracer.start_as_current_span()`
- Add relevant attributes to spans (e.g., location, destination)
- Log information within the span context

**Route Instrumentation:**

- Wrap the `/plan` route handler with a span
- Add request-specific attributes (destination, duration, etc.)
- Handle errors and mark spans appropriately

**Logging Configuration:**

- Set up structured logging that includes trace context
- Log meaningful events throughout the request lifecycle

## Success Criteria

To complete this challenge successfully, you should be able to:

- [ ] Verify that OpenTelemetry SDK is initialized in your application
- [ ] Demonstrate that traces appear in the console when you make requests
- [ ] Show that tool function spans are captured with their attributes
- [ ] Verify that Flask route spans include request information
- [ ] Demonstrate that logs include trace context for correlation

If everything is set up correctly, when you run your Flask app and submit a travel request, you should see detailed traces in the console output showing the full journey of the request, including tool calls and route handling.

![WanderAI OTel trace](../Images/wanderai-otlp-console-exporter-trace.png)

After some time, you should also see some metrics appear in the console.

![WanderAI OTel metric](../Images/wanderai-otlp-console-exporter-metric.png)

## Learning Resources

- [Microsoft Agent Framework Observability](https://learn.microsoft.com/en-us/agent-framework/user-guide/observability?pivots=programming-language-python)
- [OpenTelemetry Concepts](https://opentelemetry.io/docs/concepts/)
- [OpenTelemetry Python Documentation](https://opentelemetry.io/docs/instrumentation/python/)
- [OpenTelemetry Python API - Tracing](https://opentelemetry.io/docs/instrumentation/python/manual/)
- [OTLP Protocol](https://opentelemetry.io/docs/specs/otel/protocol/)

## Tips

- Start small - Instrument one tool first, then expand to others
- Check the console - Traces should print when requests complete
- Use meaningful attributes - Include anything that helps debugging
- Don't overload - Every span and log should have a purpose
- Test without the agent first - Make sure basic Flask routes work before adding agent complexity
- The Agent Framework provides helper functions like `configure_otel_providers()`, `get_tracer()`, and `get_meter()` that simplify setup
