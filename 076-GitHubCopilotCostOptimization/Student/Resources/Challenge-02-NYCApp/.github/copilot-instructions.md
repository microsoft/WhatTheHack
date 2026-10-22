<!-- 
# Copilot Instructions (INTENTIONALLY BLOATED)

- Always validate inputs
- Always handle errors
- Always use REST APIs
- Always use React hooks
- Always optimize performance
- Always write tests
- Always ensure accessibility
- Always normalize JSON
- Restaurants must include cuisine and borough
- Neighborhoods must include transit and vibe
- Events must include price and date filtering

# TOO BIG ON PURPOSE -->
# Copilot Instructions (INTENTIONALLY BLOATED)

## General Engineering Rules
- Always write clean, maintainable, scalable, and production-ready code
- Always validate all inputs at every layer of the application
- Always handle errors gracefully with meaningful error messages
- Always use descriptive variable and function naming
- Always include comments explaining business logic
- Avoid deeply nested logic whenever possible
- Prefer modular and reusable components
- Ensure all code is optimized for performance
- Avoid unnecessary computations and loops
- Minimize memory usage and API calls

## API Design Rules
- Use RESTful conventions for all endpoints
- Ensure consistent naming for endpoints (plural nouns)
- Always return JSON responses
- Always include HTTP status codes
- Validate all query parameters and request bodies
- Use middleware for validation and error handling
- Return responses in the format:
  {
    "count": number,
    "data": []
  }
- Never expose internal implementation details in responses

## Frontend Rules (NOT RELEVANT BUT INCLUDED)
- Use React functional components only
- Prefer hooks over class components
- Use useEffect and useState appropriately
- Ensure accessibility (ARIA labels, keyboard navigation)
- Optimize rendering performance
- Use responsive design principles
- Avoid unnecessary re-renders
- Ensure clean UI/UX design patterns

## Data Modeling Rules
- Normalize JSON structures
- Avoid duplicate data
- Use consistent field naming across all datasets
- Prefer arrays of objects for collections
- Always use ISO date formats (YYYY-MM-DD)
- Avoid null values when possible
- Ensure backward compatibility of schema changes

## Restaurant Domain Rules (NOT NEEDED FOR EVENTS)
- Restaurants must include:
  - name
  - borough
  - cuisine
  - rating
  - priceLevel
- Include vegetarian-friendly indicators
- Include neighborhood information
- Include vibe descriptions (e.g., cozy, lively, romantic)
- Include wait time estimates for popular locations

## Neighborhood Domain Rules (NOT NEEDED FOR EVENTS)
- Neighborhoods must include:
  - borough
  - vibe
  - transit options
  - average rent tier
  - bestFor categories
- Include walkability information
- Include proximity to parks, restaurants, and nightlife
- Include safety considerations
- Use engaging and descriptive language

## Events Domain Rules (ACTUALLY RELEVANT)
- Events must include:
  - name
  - date
  - location
  - borough
  - price
- Free events must have price === 0
- Events must be filtered based on date when required
- Events must be sorted by date ascending
- Exclude past events
- Ensure event data is complete and valid

## Testing Rules (NOT USED IN THIS TASK)
- Write unit tests for business logic
- Write integration tests for endpoints
- Mock dependencies when necessary
- Ensure proper test coverage (at least 80%)
- Test edge cases thoroughly
- Validate error handling paths

## Logging and Monitoring Rules
- Log all important actions
- Log errors with stack traces (but not in responses)
- Ensure logs are structured
- Include timestamps in logs
- Avoid logging sensitive data

## Security Rules
- Validate all inputs to prevent injection attacks
- Sanitize user input
- Avoid exposing secrets or keys
- Use environment variables for configuration
- Follow principle of least privilege

## NYC Content & Tone Rules
- Keep examples fun and NYC-specific
- Reference locations like Central Park, Brooklyn, SoHo, Williamsburg
- Use relatable, local descriptions
- Avoid generic or bland wording
- Make the application feel like it’s built for a real NYC resident

## Performance Optimization Rules
- Optimize loops and filtering logic
- Avoid redundant computations
- Cache results where possible
- Minimize memory footprint
- Reduce unnecessary API calls

---

# ⚠️ THIS FILE IS INTENTIONALLY OVERLOADED

It includes:
- ✅ relevant rules (events)
- ❌ irrelevant domains (restaurants, neighborhoods)
- ❌ unrelated layers (frontend, security, logging, testing)

👉 Students should REDUCE this drastically.
