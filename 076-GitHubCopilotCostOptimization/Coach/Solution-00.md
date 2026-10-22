# Challenge 00 - Prerequisites & Baseline - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

This challenge establishes the measurement baseline that all subsequent challenges compare against. Students must be able to track credit consumption accurately before they can optimize.

### Key Concepts to Explain

**Usage-Based Billing (UBB) Fundamentals:**
- Credit cost = (input tokens × input rate) + (output tokens × output rate)
- Different models have different rates (Sonnet/GPT-4 class vs. Haiku class can be 10x difference)
- VS Code Output panel shows token breakdowns per interaction
- GitHub Copilot usage dashboard shows cumulative spend

**Baseline Purpose:**
- Establishes "before" measurement for all optimization techniques
- Students should use their natural workflow—no optimization yet
- Document approach (inline completions, chat frequency, workspace references used)
- This baseline will likely be inefficient—that's intentional

### Common Blockers

**UBB Not Enabled:**
- Some organizations may still be on seat-based billing
- Students need admin access or must coordinate with billing admin
- Workaround: Coach can provide sample baseline data if UBB isn't available

**Token Visibility Issues:**
- VS Code Output panel must be configured to show GitHub Copilot Chat logs
- Some students may not see token counts if using older Copilot extension version
- Solution: Update GitHub Copilot extension to latest version

**Baseline Task Selection:**
- Task should be non-trivial (10-20 minutes of development)
- Task should be completable in multiple ways (leaves room for optimization)
- Suggested baseline tasks:
  - Implement a REST API endpoint with validation and error handling
  - Add authentication middleware to an existing service
  - Refactor a module to use dependency injection

### Expected Time

45 minutes total:
- 15 minutes: Environment setup and UBB verification
- 20 minutes: Complete baseline coding task
- 10 minutes: Document measurements and approach

### Success Criteria Validation

Students should demonstrate:
- Screenshot or screen share of VS Code Output panel showing token counts
- Screenshot of GitHub Copilot usage dashboard showing current credit balance
- Completed baseline task code (doesn't need to be perfect)
- Written documentation: total credits consumed, features used, approach taken

### Hints to Share

- Don't optimize yet! Use your natural workflow
- Document everything—this is your "before" picture
- If credits seem surprisingly high, that's normal and expected
- Track not just total credits, but which interactions cost the most
- Note: inline completions are typically much cheaper per-interaction than chat/edits

### Reference Measurements

Typical baseline measurements for a 15-20 minute coding task:
- Unoptimized: 50-80 credits (using GPT-4 class model, verbose chat, broad references)
- Expected after optimization: 10-20 credits (targeted instructions, efficient model, pinned attachments)

### Additional Resources for Coach

- Ensure Resources.zip contains `baseline-task.md` with clear requirements
- Consider providing a reference completion for teams that get stuck
- Have sample token breakdowns ready to share if students can't see theirs
