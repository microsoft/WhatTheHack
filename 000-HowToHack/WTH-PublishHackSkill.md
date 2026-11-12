# Publishing with the publish-wth-hack Skill

Maintainers can explicitly invoke the
[publish-wth-hack Copilot skill](../.github/skills/publish-wth-hack/SKILL.md)
after a contribution has merged. The skill is manual: installing it or merging
a content PR does not trigger publication. Use it in a Copilot client that
supports repository skills; the frontmatter disables automatic invocation on
clients that honor that setting.

Start with a read-only plan, replacing the placeholders with a real merged PR
URL or exact hack folder:

```text
/publish-wth-hack <merged PR URL> plan only
/publish-wth-hack microsoft/WhatTheHack <NNN-HackFolder> plan only
```

Identify the publication source explicitly. A skill installed in your personal
fork does not authorize publishing fork content or writing to Microsoft
repositories. The skill verifies live branches, merged PR provenance, and the
selected hack before asking for missing material inputs.

To authorize publication, explicitly name the source and target:

```text
/publish-wth-hack <merged PR URL> publish from microsoft/WhatTheHack to microsoft/WhatTheHack-Codespaces
```

For hacks with an existing top-level devcontainer, publication dispatches the
target's existing **Daily Pull** workflow. Despite its name, that workflow is
manually dispatched and synchronizes **all eligible hacks**, not just yours.
You need authenticated GitHub access with permission to dispatch it. The skill
waits for the exact run and compares the copied configuration and student
resources with the source; a green run alone is insufficient. Hacks without
Codespaces configuration skip these steps without creating new configuration.

The skill prepares a configuration-specific Codespaces **creation-page** link
using **Share a deep link**, with **Quick start unchecked**. It never creates a
Codespace. If the current URL format or selected configuration cannot be
verified, it asks for the link from the share dialog instead of guessing.
An available authenticated private-shortener integration can reuse or create a
matching short link. Without one, the result is the long URL and a suggested
alias for manual shortening; no shortener credentials belong in the repository.

Homepage categories are recommendations until a human approves the exact
categories, title, and link. To request a homepage PR, explicitly invoke the
skill with `create homepage PR` and provide that editorial approval. The skill
checks for existing entries and matching PRs, then creates or reuses a feature
branch/PR containing only approved root `README.md` changes. It never auto-merges.
Synchronization and link preparation alone leave the homepage unchanged.
