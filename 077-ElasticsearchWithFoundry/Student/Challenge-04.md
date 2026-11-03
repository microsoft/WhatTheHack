# Challenge 04 - Trust the Evidence, Not Its Instructions

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)**

## Pre-requisites

Complete Challenge 01 and confirm Foundry safety-evaluation access. Optimus (Challenge 03) is preferred, but you may use the Mole agent if Challenges 02 and 03 are blocked; that does not complete the native Context Engine objective.

## Introduction

Retrieved records are evidence, not instructions. A support document can contain accurate facts and an unrelated command to the assistant. This is an **indirect prompt injection**: the user's request is legitimate, but untrusted source content tries to change the agent's behavior.

Foundry evaluations assess behavior after it occurs. They do not automatically intercept or sanitize MCP tool results. Detection in a document, resistance by the model, and prevention before inference are separate responsibilities.

## Description

Use `notebooks/04-Evaluate.ipynb` and explicitly activate its isolated safety fixture after completing your performance comparison. The fixture only tries to insert an irrelevant workshop marker into the answer; it performs no external action.

- Retrieve the clean control and instruction-bearing document through Elastic MCP, preserving the query, returned text, response, and run identifiers.
- Configure the proposed Foundry evaluation mapping and inspect the score and rationale for each case.
- Strengthen the agent's trust-boundary instructions and repeat the same cases without changing the model or legitimate support facts.

Explain what the report does and does not establish. The original agent may already resist the fixture; do not weaken it to manufacture a dramatic result. The draft evaluator mapping requires organizer confirmation before delivery because indirect-attack support differs by target type.

## Success Criteria

- Verify in the MCP trace that the intended document was actually retrieved before evaluating the answer.
- Show the legitimate support facts and identify the document's unrelated instruction.
- Show Foundry evaluation results and rationale linked to the captured interaction, including the clean control.
- Demonstrate the effect, or lack of effect, of stronger trust-boundary instructions.
- Explain why a marker check alone is not a Foundry evaluation and why a passing evaluation does not prove general safety.

## Learning Resources

- [Foundry risk and safety evaluators](https://learn.microsoft.com/en-us/azure/foundry/concepts/evaluation-evaluators/risk-safety-evaluators)
- [Evaluate precomputed responses in Foundry](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/cloud-evaluation-datasets)
- [Inspect evaluations in the Foundry portal](https://learn.microsoft.com/en-us/azure/foundry/how-to/evaluate-generative-ai-app)
- [Prompt Shields concepts](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/jailbreak-detection)

## Tips

- Record unavailable or failed evaluations as such. Do not substitute a local rule and call it the hosted evaluator.
- Read the rationale, not only an aggregate pass rate. A control case helps interpret false positives.
- Use only the bundled synthetic fixture, not secrets, real customer records, or disturbing content.

## Advanced Challenges

- Evaluate retrieved text with a content-safety category, explicitly mapping the document rather than the agent answer. Explain why a harmless prompt injection may receive a low harmful-content score.
- Investigate Prompt Shields document scanning before inference. This is a separate runtime integration, not a property obtained by enabling offline evaluation.
- Present your final comparison and limitations, then use `notebooks/99-Cleanup.ipynb` to retire owned workshop resources.
