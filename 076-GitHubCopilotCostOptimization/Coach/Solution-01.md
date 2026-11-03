# Challenge 01 - Spec-Driven Development with Spec Kit - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

# Coach Guide: Direct Prompt vs. Spec-Driven Development

## Purpose

This guide helps coaches facilitate an experiment comparing two ways of building the same React and TypeScript application with GitHub Copilot:

1. A direct implementation prompt.
2. A structured Markdown specification using Spec-Driven Development (SDD).

The goal is not to prove that one approach is universally better. Participants should observe how context influences implementation time, credit consumption, interruptions, interventions, rework, and the delivered application.

## Learning Outcomes

By the end of the activity, participants should be able to:

- Explain the role of a specification as implementation context.
- Compare direct prompting and SDD under equivalent conditions.
- Distinguish functional effectiveness from implementation efficiency.
- Include specification preparation when evaluating full-cycle efficiency.
- Discuss experimental results without generalizing from a single run.

## Recommended Duration

| Activity | Suggested time |
|---|---:|
| Introduction and environment check | 10 minutes |
| Direct prompt implementation | 20–30 minutes |
| SDD implementation | 20–30 minutes |
| Comparison and discussion | 20 minutes |
| Total | 70–90 minutes |

Do not impose an implementation time limit if it would prevent participants from completing and manually verifying the application.

## Coach Preparation

Before the session:

- Confirm that VS Code, Node.js, npm, and GitHub Copilot are available.
- Select one GitHub Copilot model to use in both runs.
- Keep the provided `sdd.md` content available.
- Prepare a timer and measurement worksheet.
- Ensure participants can inspect Copilot credit consumption.
- Ask participants to close unrelated conversations and projects.
- Explain that generated files cannot be reused between runs.

The folders must begin empty. Existing scaffolds, templates, or files may affect the comparison and should be recorded if used.

## Fairness Rules

The coach must enforce the following controls:

- Same computer and environment.
- Same VS Code and GitHub Copilot versions.
- Same Copilot model.
- Same application scope and manual verification checklist.
- Separate empty folders and new conversations.
- No reuse of generated code between runs.
- No additional implementation instructions unless required to unblock progress.
- Every clarification, correction, or intervention must be recorded.

Do not steer Copilot toward a specific framework choice, package, UI design, or solution unless the participant is blocked. Any such assistance counts as an intervention.

## Facilitation Flow

### 1. Introduce the Experiment

Explain that the experiment evaluates three dimensions:

- **Effectiveness:** whether the application satisfies the requirements.
- **Implementation efficiency:** effort after the prompt or specification is ready.
- **Full-cycle efficiency:** implementation effort plus specification preparation.

Remind participants that a functional tie can still reveal differences in time, cost, ambiguity, and rework.

### 2. Run the Direct Prompt Approach

Before the participant submits the prompt:

- Confirm the folder is empty.
- Confirm a new Copilot conversation is open.
- Record the selected model.
- Prepare the timer.

Start timing when the implementation prompt is sent. During execution, observe without directing the participant.

Record:

- Start and end time.
- Credits consumed.
- Questions asked by Copilot.
- Dependency or tooling decisions requested.
- Participant interventions.
- Errors, failed commands, and rework.
- Any functionality added beyond the requested scope.

Stop timing only after the application is running and the full manual checklist has been completed.

### 3. Run the SDD Approach

Before the second run:

- Confirm a different empty folder is being used.
- Create the provided `sdd.md` in the project root.
- Open a new Copilot conversation.
- Select the same model.
- Verify that no files from the first implementation were reused.

Start timing when the participant sends the instruction to read and implement `sdd.md`.

Apply the same observation and stopping rules used in the direct prompt run. Do not give the SDD implementation credit for additional features that were not required by the specification.

### 4. Perform Manual Verification

Use exactly the same checklist for both applications:

- [ ] Create a note with a title and content.
- [ ] Create a note without content.
- [ ] Reject creation when the title is empty or whitespace-only.
- [ ] Display all notes created during the session.
- [ ] Update an existing note’s title and content.
- [ ] Reject an update with an empty title.
- [ ] Update without creating a duplicate note.
- [ ] Delete an existing note.
- [ ] Confirm that the deleted note disappears.
- [ ] Reload the page and confirm that notes may be lost.
- [ ] Confirm no backend, database, or persistent storage is used.
- [ ] Confirm no automated tests were added.

Record failures and corrections instead of silently fixing them.

## Measurement Definitions

Use consistent definitions across both runs:

- **Question:** Copilot explicitly requests information or a decision.
- **Interruption:** progress pauses because participant input is required.
- **Intervention:** the participant supplies a correction, additional instruction, command, or code change.
- **Error:** a build, runtime, dependency, or functional failure.
- **Rework:** work required to correct a missing or incorrect result.
- **Implementation time:** time from sending the implementation instruction until the application runs and passes manual verification.
- **Specification preparation cost:** time and credits used to author or refine the specification, excluding implementation.

If the specification was supplied ready-made, record its known preparation cost separately. If that cost is unavailable, mark it as “not measured” rather than treating it as zero.

## Results Worksheet

| Aspect | Direct prompt | SDD with ready specification |
|---|---:|---:|
| Model used | | |
| Implementation time | | |
| Implementation credits | | |
| Questions asked | | |
| Interruptions | | |
| User interventions | | |
| Errors | | |
| Rework actions | | |
| Requirements passed | /12 | /12 |
| Out-of-scope features | | |
| Qualitative UX score | /5 | /5 |

Record SDD preparation separately:

| Specification metric | Result |
|---|---:|
| Preparation time | |
| Preparation credits | |
| Number of revisions | |

Calculate full-cycle SDD values as:

$$
T_{\mathrm{SDD\ total}}
=
T_{\mathrm{specification}}
+
T_{\mathrm{implementation}}
$$

$$
C_{\mathrm{SDD\ total}}
=
C_{\mathrm{specification}}
+
C_{\mathrm{implementation}}
$$

## Qualitative UX Guidance

To reduce subjectivity, score both applications from 1 to 5 using the same criteria:

- Form and action clarity.
- Validation feedback.
- Note readability.
- Discoverability of edit and delete actions.
- Overall consistency and usability.

Visual polish is secondary. It must not compensate for missing functional requirements.

## Debrief Questions

Ask participants:

1. Did both applications satisfy the same requirements?
2. Which approach required more decisions during implementation?
3. Which ambiguities appeared in the direct prompt run?
4. Did SDD eliminate ambiguity or move decisions to specification preparation?
5. Which approach used less implementation time and fewer credits?
6. Does the conclusion change when specification preparation is included?
7. What specification content had the greatest implementation impact?
8. Which parts of the specification could be reused?
9. How might a larger application change the outcome?
10. How might later requirement changes affect each approach?

## Coaching Notes

Avoid announcing an expected winner. Common valid outcomes include:

- Both approaches deliver equivalent applications.
- SDD reduces interruptions but costs more overall for a small application.
- The direct prompt is faster but requires more decisions or corrections.
- The structured specification improves consistency without reducing credits.
- Natural model variation outweighs the difference between approaches.

Treat every result as an observation, not proof. Encourage participants to describe what happened, identify contributing factors, and state the experiment’s limitations.

## Completion Criteria

The challenge is complete when:

- Both applications have been built independently.
- Both have been evaluated with the same checklist.
- All measurements and interventions have been recorded.
- Implementation and specification preparation costs remain separate.
- Participants can explain the observed tradeoffs and limitations.
