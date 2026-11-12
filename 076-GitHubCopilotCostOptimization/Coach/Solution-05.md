# Challenge 05 - Context Window Management - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)** - [Next Solution >](./Solution-06.md)

## Notes & Guidance

This challenge teaches proactive context management vs. reactive recovery. The biggest avoidable cost is not running `/compact` until context rot has already degraded quality.

### Key Concepts to Explain

**Context Rot Timeline:**
- 0-60% capacity: Quality remains high
- 60-70% capacity: First signs of degradation (inconsistencies)
- 70-85% capacity: Noticeable quality loss, forgotten requirements
- 85-100% capacity: Severe degradation, expensive recovery loops

**Two Commands, Different Purposes:**
- `/compact`: Summarizes previous work, preserves state, preserves cache (steering wheel)
- `/clear`: Wipes everything, cold cache restart (reset button)

**Natural Breakpoints for Compaction:**
- Feature complete and tests passing
- Architecture decision made
- Switching to new topic/module
- Before context hits 60% utilization

### Expected Time

45 minutes:
- 15 minutes: Observe context rot (Part A)
- 20 minutes: Demonstrate proactive compaction (Part B)
- 10 minutes: Document findings

### Success Criteria Validation

Students should demonstrate measurable quality degradation after 70% context utilization and show credit savings from proactive `/compact` vs. letting context rot.

### Hints to Share

- Context window utilization visible in VS Code status bar or Output panel
- Run `/compact` before you feel the pain, not after
- Natural breakpoints: "I just finished X, now starting Y"—compact at the transition
- `/compact` preserves cache; `/clear` forces cold restart
- The cost isn't running `/compact` too often—it's running it too late
