# Challenge 02 - Context Engineering - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This challenge teaches students that persistent context has recurring costs. The goal is to minimize always-on overhead while maintaining quality through scoped instructions and precise attachments.

### Key Concepts to Explain

**The Three Types of Context Costs:**

1. **Persistent Instructions (recurring cost):**
   - `.github/copilot-instructions.md` loads on EVERY interaction
   - Example: 1500-token global file = 1500 tokens × every chat/edit call
   - Target: keep global instructions under 500-1000 tokens

2. **GitHub Copilot Skills (conditional cost):**
   - Only load when explicitly invoked
   - Example: `@workspace /new` only loads creation templates when called
   - Best for: task-specific patterns that don't apply to all work

3. **Attachments (per-call cost):**
   - You control exactly what's included each time
   - Example: `#file:src/api/routes.ts` only loads when you attach it
   - `#Codebase` can pull in thousands of unnecessary tokens

### Part A: Instruction Scoping Strategy

**Audit Process:**

Help students categorize their bloated instructions:

- **Keep Global (under 500 tokens):**
  - Code style preferences that apply universally (e.g., "prefer functional patterns")
  - Quality standards (e.g., "always handle errors explicitly")
  - Organization-wide conventions

- **Move to Language-Specific:**
  - `.github/copilot-instructions-python.md` for Python-only rules
  - `.github/copilot-instructions-typescript.md` for TypeScript-only rules
  - These only load when working in that language

- **Move to Path-Specific:**
  - `src/api/.github/copilot-instructions.md` for API-specific patterns
  - `tests/.github/copilot-instructions.md` for testing conventions
  - These only load when working in that directory

- **Convert to Skills:**
  - Task-specific templates (e.g., "how to write a migration")
  - Conditional patterns (e.g., "when adding a new model, do X")

**Expected Savings:**

- Before: ~1500 tokens per interaction (global instructions)
- After: ~400 tokens global + ~200 tokens scoped (only when in scope)
- Result: 60-70% reduction in instruction overhead for most interactions

### Part B: Attachment Precision

**Common Anti-Pattern:**

```
Prompt: "Refactor the authentication logic"
Attachments: #Codebase
```
This pulls in everything—potentially 50,000+ tokens for a large repo.

**Optimized Pattern:**

```
Prompt: "Refactor the authentication logic"
Attachments: 
  - #file:src/auth/middleware.ts:1-50
  - #file:src/auth/types.ts
  - #file:tests/auth.test.ts
```
This pulls in exactly what's needed—perhaps 500 tokens.

**Demonstration Exercise:**

Have students complete the same refactor twice:
1. With `#Codebase` (record token count from Output panel)
2. With pinned files (record token count)

Typical results: 10,000+ tokens → 800 tokens (90%+ reduction)

### Common Blockers

**Students Don't Know What to Keep Global:**

Rule of thumb: If a rule only applies to 20% of your codebase, it shouldn't be global.

**Path-Specific Instructions Not Loading:**

GitHub Copilot walks up the directory tree looking for `.github/copilot-instructions.md` files. Ensure:
- Directory structure is correct
- File is named exactly `.github/copilot-instructions.md` (not `.github/copilot-instructions-api.md` in the api folder)

**Can't Measure Token Reduction:**

- VS Code Output panel (View → Output → "GitHub Copilot Chat") shows token counts
- If not visible, update GitHub Copilot extension to latest version

### Expected Time

60 minutes total:
- 20 minutes: Audit and categorize global instructions
- 20 minutes: Restructure into scoped files
- 20 minutes: Test attachment precision and measure savings

### Success Criteria Validation

Students should demonstrate:
- Global `.github/copilot-instructions.md` reduced to under 500 tokens
- At least one path-specific or language-specific instruction file created
- Token comparison showing savings from pinned attachments vs. `#Codebase`
- Same baseline task completed with reduced credit cost

### Hints to Share

- Start by asking: "Does this rule apply to ALL code I write?" If no, scope it
- Use language-specific files for linting/formatting rules that vary by language
- Use path-specific files for architectural patterns (e.g., API conventions in `src/api/`)
- Pin files when you know exactly what you need; use `#Codebase` only for discovery
- The goal isn't zero instructions—it's right-sized instructions

### Reference Solutions

Typical restructuring:

**Before (1500 tokens global):**
```
.github/copilot-instructions.md (all rules)
```

**After (400 tokens global + scoped):**
```
.github/copilot-instructions.md (universal rules, ~400 tokens)
.github/copilot-instructions-python.md (Python-specific, ~300 tokens)
.github/copilot-instructions-typescript.md (TypeScript-specific, ~250 tokens)
src/api/.github/copilot-instructions.md (API patterns, ~200 tokens)
```

Students working in `src/api/*.ts` now load: 400 + 250 + 200 = 850 tokens (vs. 1500 before)
