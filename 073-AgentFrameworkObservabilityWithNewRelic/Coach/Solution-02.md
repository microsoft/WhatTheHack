# Challenge 02 - Build Your MVP - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

Guide attendees as they build their first agent-powered Flask app from scratch using the Microsoft Agent Framework.

## #Key Points

- Start simple: Minimal Flask app first.
- Agent creation: Use Agent Framework docs.
- Tool registration: Define and register tools.
- Incremental build: Test in small steps.

### Tips

- Check Flask basics understanding.
- Point out common mistakes (e.g., forgetting to register tools).
- Encourage debugging with print/log statements.
- Reference Flask Quickstart and Agent Framework examples.

### Pitfalls

- Overcomplicating the initial app.
- Not testing incrementally.
- Confusing Flask logic with agent logic.

### Success Criteria

- Working Flask app with agent responding to user input.
- At least one tool registered and callable.
- Readable, logically organized code.

### Example solution implementation

The [Example solution implementation](./Solutions/Challenge-02/) folder contains sample implementation of the challenge 2. It contains:

- **[web_app.py](./Solutions/Challenge-02/web_app.py)**: Python Flask web application with Agent framework implementation
- **[templates/index.html](./Solutions/Challenge-02/templates/index.html)**: sample web UI form
- **[templates/result.html](./Solutions/Challenge-02/templates/result.html)**: sample web UI travel planner result view
- **[templates/error.html](./Solutions/Challenge-02/templates/error.html)**: sample web UI error view
- **[static/styles.css](./Solutions/Challenge-02/static/styles.css)**: CSS files for HTML views

---

## Common Issues & Troubleshooting

### Issue 1: OpenAI/GitHub API Key Errors

**Symptom:** `AuthenticationError` or `Invalid API Key` when running the agent
**Cause:** Missing or incorrect API key in environment variables
**Solution:**

- Verify `MSFT_FOUNDRY_ENDPOINT` or `MSFT_FOUNDRY_API_KEY` is set in `.env`
- Check for extra spaces or quotes around the key
- Ensure `load_dotenv()` is called before accessing env vars
- Test key with a simple API call outside Flask

### Issue 2: Flask App Not Starting

**Symptom:** `Address already in use` or Flask doesn't respond
**Cause:** Port conflict or Flask not configured correctly
**Solution:**

- Change port: `app.run(port=5001)` or use different port
- Kill existing process: `lsof -i :5002` then `kill -9 <PID>`
- Ensure `if __name__ == "__main__":` block is present
- Check for syntax errors with `python -m py_compile web_app.py`

### Issue 3: Agent Not Using Tools

**Symptom:** Agent responds but doesn't call weather/datetime tools
**Cause:** Tools not registered or prompt doesn't trigger tool use
**Solution:**

- Verify tools are passed to `ChatAgent(tools=[...])`
- Check tool function signatures have proper type hints
- Ensure docstrings describe when tool should be used
- Test with explicit prompts like "What's the weather in Paris?"

### Issue 4: Async/Await Errors

**Symptom:** `RuntimeError: This event loop is already running` or similar
**Cause:** Mixing sync Flask with async agent calls incorrectly
**Solution:**

- Use `asyncio.run()` or `loop.run_until_complete()` in Flask routes
- Consider using `async def` routes with Flask-async or Quart
- Reference the solution code for correct async patterns

### Issue 5: Template Not Found

**Symptom:** `jinja2.exceptions.TemplateNotFound`
**Cause:** Templates folder not in correct location or named incorrectly
**Solution:**

- Ensure `templates/` folder is in same directory as `web_app.py`
- Check filename matches exactly (case-sensitive)
- Verify Flask app is created in the right directory context

---

## What Participants Struggle With

- **Tool Function Design:** Help them understand tools need clear docstrings and type hints for the agent to use them correctly
- **Flask + Async:** Watch for participants confused about running async agent code in sync Flask routes
- **Prompt Engineering:** Guide them to write prompts that naturally trigger tool usage
- **Error Handling:** Encourage wrapping agent calls in try/except blocks early
- **Incremental Testing:** Push them to test each piece (Flask alone, agent alone, then together)

---

## Time Management

**Expected Duration:** 1.5 hours
**Minimum Viable:** 1 hour (basic Flask app with one working tool)
**Stretch Goals:** +30 minutes (multiple tools, better UI, error handling)

---

## Validation Checklist

Coach should verify participants have:

- [ ] Flask app starts without errors on specified port
- [ ] Home page (`/`) renders the travel planning form
- [ ] Form submission triggers agent and returns a travel plan
- [ ] At least one tool (weather or datetime) is called by the agent
- [ ] Result page displays the generated travel plan
- [ ] Error page handles exceptions gracefully
- [ ] Code is organized and readable (not one giant function)
