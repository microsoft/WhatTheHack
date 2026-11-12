# Publishing a Hack: Maintainer Tasks

After a hack contribution is merged, maintainers can perform two independent
tasks with Copilot skills: propose its homepage placement and synchronize its
existing Codespaces resources. Creating the Codespaces deep link and maintaining
its Microsoft aka.ms short link remain **manual tasks**.

Installing these skills or merging a content PR triggers nothing. Use a Copilot
client supporting repository skills. Both skills disable automatic invocation
on clients that honor that frontmatter setting and require explicit user intent
before writes, regardless of the client.

## Publish the Hack on the Homepage

The [publish-wth-hack skill](../.github/skills/publish-wth-hack/SKILL.md) handles
only entries in root `README.md`. It verifies the merged contribution or existing
hack on the intended publication branch, reads its learning objectives, and
recommends appropriate existing categories. A hack can belong in several
categories; links use the actual description path and casing.

Start with a read-only proposal, replacing placeholders with a real merged PR
URL or exact hack folder:

```text
/publish-wth-hack <merged PR URL> plan only
/publish-wth-hack microsoft/WhatTheHack <NNN-HackFolder> plan only
```

Approve the exact categories, display title, and destination before homepage
edits. To request a PR explicitly:

```text
/publish-wth-hack microsoft/WhatTheHack <NNN-HackFolder> create homepage PR
```

The PR request does not replace editorial approval. Once the exact entries are
approved, the skill creates or reuses a feature branch/PR containing only the
approved root `README.md` changes. Existing entries and matching PRs are checked
to avoid duplicates. It never merges or enables auto-merge; an open PR still
requires the normal human review and merge process.

This skill does not dispatch synchronization, create Codespaces links, shorten
URLs, or require those tasks to recommend homepage placement.

## Synchronize WhatTheHack-Codespaces

The [sync-wth-codespaces skill](../.github/skills/sync-wth-codespaces/SKILL.md)
triggers the Codespaces target repository's existing **Daily Pull** workflow
and verifies the copied content. Despite its name, the workflow is manually
dispatched, with no schedule or hack-specific inputs.

Inspect the intended synchronization first:

```text
/sync-wth-codespaces microsoft/WhatTheHack to microsoft/WhatTheHack-Codespaces plan only
```

Authorize synchronization explicitly, optionally identifying a new hack to
focus content verification:

```text
/sync-wth-codespaces microsoft/WhatTheHack to microsoft/WhatTheHack-Codespaces <NNN-HackFolder> sync
```

Dispatch always synchronizes **all eligible hacks**, not just the named hack.
Without a hack identifier, the skill verifies all eligible source hacks. You
need authenticated source/target read access and permission to dispatch the
target workflow. The expected source default branch is `master` and target
branch is `main`; the skill verifies live metadata and workflow behavior.

The workflow copies `.devcontainer/<hack>/` and
`<hack>/Student/Resources/` into matching paths in the target. The skill records
the exact run, waits for completion, checks logs, and compares complete source
and target subtrees. A green run alone is insufficient because per-hack errors
can be caught without failing the overall workflow. No-change runs are valid
when content matches. Hacks without top-level Codespaces configuration are not
applicable; the skill does not invent configuration.

The skill reports exact run details, verified revisions and paths, and any
incomplete verification. It does not edit the homepage, generate a deep link,
shorten a URL, or create a Codespace.

## Use the WTHAuthor Agent Instead

Select the repository's [WTHAuthor agent](../.github/Agents/WTHAuthor.chatmode.md)
in a client that supports it, then request the desired task in natural language.
For example:

```text
Recommend homepage categories for <merged PR URL>. Do not make changes yet.
Create a homepage PR in microsoft/WhatTheHack for <NNN-HackFolder> using the entries I approved.
Synchronize microsoft/WhatTheHack-Codespaces from microsoft/WhatTheHack and verify <NNN-HackFolder>.
```

The agent loads the corresponding skill. You can request both tasks, but each
retains its own authorization and verification gates; requesting one does not
trigger the other. The agent still needs human editorial approval for homepage
entries and an explicit request to open a PR. It leaves deep links and aka.ms
maintenance to a human.

For both direct skills and the agent, identify the intended source explicitly.
A skill installed in a personal fork does not authorize publishing that fork
or writing to Microsoft repositories. The synchronization workflow clones the
main Microsoft repository, not your installation fork. Do not use it to publish
content that exists only in a fork or unmerged PR.

## Manually Create the Codespaces Deep Link

For a new hack with Codespaces support, complete synchronization and verify the
target configuration/resources before creating its link. If the hack has no
Codespaces configuration, this task and the related short link are not applicable.

Follow GitHub's documented
[Share a deep link procedure](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces):

1. Open the confirmed [WhatTheHack-Codespaces repository](https://github.com/microsoft/WhatTheHack-Codespaces)
   and select the verified target branch (normally `main`).
2. Select **Code > Codespaces**, then the **...** menu and **Share a deep link**.
3. Leave **Quick start unchecked** so attendees get the creation/options page,
   not a quickstart/resume page.
4. Under **Configuration file**, select the new hack's exact
   `.devcontainer/<NNN-HackFolder>/devcontainer.json`. Do not leave it on an
   unspecified default or select a different hack.
5. Copy the generated URL from the **URL** tab. Use GitHub's generated link;
   do not guess query parameters or manually concatenate unescaped paths.
6. Open only the link's creation/options page and confirm the target repository,
   branch, and configuration. Do not click **Create codespace**. Copying and
   inspecting the link does not require provisioning a Codespace.

If the configuration is missing from the selector or the page shows incorrect
options, stop and resolve the configuration/synchronization issue before sharing
the link. A login redirect or successful page load alone is not validation.
Neither skill nor WTHAuthor performs this manual link-creation task.

## Manually Create or Update the Microsoft aka.ms Link

Using your authorized Microsoft aka.ms link-management access, create or update
the hack's Codespaces short link to the manually verified long URL. If you lack
access, ask an authorized maintainer to perform this task; do not add credentials
to the repository or invent a shortener API.

- Check the existing hack documentation and aka.ms records for a matching alias
  before creating one. Reuse an existing correct link rather than making duplicates.
- If an existing alias needs a new destination, confirm its ownership and intended
  usage before updating it. Do not overwrite another hack's or configuration's
  link. Use a distinct approved alias where necessary.
- After saving, check the short link's destination and creation-page selections
  without provisioning a Codespace. Do not claim a suggested alias is a working
  link until it has actually been created and verified.
- Record/share the verified long URL and aka.ms link with the hack maintainers.
  Any edits to hack instructions to include the link are a separate content
  change, not part of the README-only homepage skill.

Neither skill nor WTHAuthor calls the shortener. Keep any missing link, access
request, failed synchronization, or unmerged homepage PR explicit in the
maintainer handoff instead of calling the entire publication complete.
