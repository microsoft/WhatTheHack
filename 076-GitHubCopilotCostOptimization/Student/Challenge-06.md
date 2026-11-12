# Challenge 06 - Token Golf Competition 🏌️

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)**

## Introduction

Token golf is the art of achieving high-quality code output with minimal credit spend. In this final challenge, teams compete to complete the same coding task with the lowest credit consumption while meeting all acceptance criteria. This is where you apply everything you've learned: context engineering, model selection, session hygiene, and spec-driven development.

Your coach has already completed this task and established a "par" score—the credit cost of a well-optimized solution. Can you beat par?

## Description

Every team builds the same app from scratch: a weather dashboard. There is no starter codebase and no pre-written spec handed to you—you decide the project structure, prompting approach, model choice, and any Copilot instructions or context files you set up. Multiple winners will be selected based on lowest token but also the best ROI of tokens as well.

### App Requirements

Build a weather dashboard. A user should be able to search for a city and see its current weather, and the dashboard should also show the last five cities the user searched for.

- Let a user search for a city and display its weather: city name, temperature, weather condition, humidity, and wind speed
- Show the last five cities the user searched for
- Use whatever frontend stack, weather data source, styling approach, and component structure you think is most cost-effective to build


## Success Criteria

To complete this challenge successfully, you should be able to:

- Demonstrate a working weather dashboard with no backend
- Verify that searching for a city displays its city name, temperature, weather condition, humidity, and wind speed
- Show that the last five searched cities are displayed and persist across a page refresh using local storage
- Demonstrate the techniques used to achieve your final credit usage score
- Show a screenshot of your working dashboard alongside your final credit usage

## Learning Resources

- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot/using-github-copilot/best-practices-for-using-github-copilot)
- [Prompt Engineering Guide](https://www.promptingguide.ai/)
- [Test-Driven Development Fundamentals](https://martinfowler.com/bliki/TestDrivenDevelopment.html)

## Tips

- Start with the spec, not the code—what are the acceptance criteria?
- Write failing tests first to establish your deterministic feedback loop
- Choose your model based on the complexity of each subtask
- Track credits as you go, not just at the end
- If you get stuck in a high-cost loop, reset: use `/clear` and try a different approach
- Remember that the fastest path isn't always the cheapest—an extra minute planning can save 20 credits executing