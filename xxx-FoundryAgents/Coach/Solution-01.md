# Challenge 01 - Your First Foundry Agent (Portal) - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This challenge is intentionally portal-based to give students a low-friction first experience with Microsoft Foundry agents. The goal is to build intuition for how agents, system instructions, and model connections work before moving to code in later challenges.

### Key Coaching Points

- **Portal vs. Production:** Make sure students understand the portal is for prototyping and experimentation. In production, agents are deployed and managed via the Azure CLI, Bicep/Terraform, and the Agent Framework SDK. Ask students: *"Why wouldn't you use the portal to deploy 50 agents across 3 environments?"* The answer should touch on repeatability, version control, CI/CD pipelines, and infrastructure-as-code.

- **This is NOT Copilot Studio:** Students coming from Power Platform backgrounds may confuse this with Copilot Studio. Key differences to emphasize:
  - Microsoft Foundry = pro-developer, code-first, full Azure AI model access, extensible with custom tools and code
  - Copilot Studio = low-code/no-code, business user focused, Microsoft 365 ecosystem, pre-built connectors
  - If a student asks "how is this different from Copilot Studio?" — the short answer is: Foundry gives you full control over the model, the infrastructure, and the deployment pipeline. Copilot Studio abstracts most of that away.

### Agent 1: TravelAgent Walkthrough

Students should navigate to [ai.azure.com](https://ai.azure.com), open their project, and create a new agent. The portal flow is:

- Open the project created in Challenge 00
- Go to the **Agents** section in the left nav
- Click **+ New agent**
- Set agent name to `TravelAgent`
- Under model selection, pick the `gpt-5.1` deployment that was created during infrastructure setup
- Paste the system instructions provided in the student guide into the **Instructions** field
- Use the **Playground** panel on the right to test conversations

Expected behavior for the TravelAgent:
- When asked about a trip to Japan, it should ask clarifying questions about budget, interests (culture, food, nature, etc.), and travel dates before suggesting an itinerary
- When asked about packing for Patagonia, it should give practical hiking/weather-specific advice
- When asked to compare beach destinations, it should ask about budget constraints and then provide a structured comparison

If the agent is not asking clarifying questions, the student's system instructions may not have been entered correctly. Have them double-check.

### Agent 2: Custom Agent Guidance

This is where students get creative. Coach should:

- Encourage students to pick a domain they are genuinely interested in (sports analyst, recipe assistant, code reviewer, fitness coach, etc.)
- Review their system instructions for specificity — vague instructions like "be helpful" produce generic responses
- Challenge them to add guardrails (e.g., "If asked about medical advice, redirect the user to consult a professional")
- Have them demonstrate at least one multi-turn conversation where context is maintained across turns

Good system instructions typically include:
- A clear role/persona
- Tone and style guidance
- Domain expertise boundaries
- What the agent should and should not do
- When to ask clarifying questions

### Common Issues

- **Student can't find the Agents section:** Make sure they are in the correct project. The Agents tab appears in the left navigation under the project.
- **Model not available for selection:** The `gpt-5.1` model deployment must have been created in Challenge 00. If it's missing, they need to go back and deploy the model.
- **Agent gives random/unrelated responses:** System instructions were likely not saved. Have the student re-enter them and confirm the save.
- **Student asks about API/SDK access:** Tell them to hold that thought — Challenge 02 will move them to code-based agent creation. The purpose of this challenge is to build understanding of the concepts first.

### Discussion Prompt (Optional)

After both agents are working, consider asking the squad:
- *"What made a system instruction effective vs. ineffective?"*
- *"If you needed to deploy 100 of these agents with slightly different instructions, would the portal work? What would you use instead?"*
- *"How would you version-control your system instructions?"*

These questions set up the transition to later challenges where students work with the SDK and CLI.
