---
name: rename-wth-hack
description: 'Rename a What The Hack folder, assign a hack number before publishing, update repository references, and synchronize its devcontainer configurations. Use when asked to rename this hack to a new name, assign this hack a number, change a hack folder prefix, or update a hack number.'
argument-hint: '<current hack folder> to <new folder name or hack number>'
---

# Rename a What The Hack Hack

Complete the rename in the current repository, including references and both
devcontainer configurations. Do not merely suggest changes.

## Example requests

- `/rename-wth-hack xxx-ElasticSearchWithFoundry to 077-ElasticsearchWithFoundry`
- "Rename this hack to 077-ElasticsearchWithFoundry."
- "Assign xxx-MyNewHack hack number 078."

## 1. Resolve the request and inspect

- Identify the repository root and current top-level hack folder from the request
  or active context. Ask the author if more than one folder could be intended.
- For a number-only request, format an integer from 0 through 999 as three digits
  and replace the existing `xxx-` or three-digit prefix. Preserve the remaining
  suffix exactly, including capitalization. Ask if the current naming format or
  requested number is ambiguous or invalid.
- For a full folder-name request, require `NNN-<nonempty suffix>` and preserve the
  author's spelling and capitalization. Reject paths outside the repository,
  path separators, and traversal components. Ask for clarification rather than
  guessing a technology name or correcting its case.
- Inspect the worktree status and relevant files before editing. Preserve all
  unrelated changes, including untracked files inside the folders being moved.
- Check both the hack destination and `.devcontainer/<new-folder>` destination.
  Never overwrite or merge an existing destination. A source already using the
  requested name needs no move; still check references and configuration parity.
- If a different hack already uses the requested number, ask the author to
  resolve the collision before making changes.
- Locate the hack's `Student/Resources/.devcontainer/devcontainer.json` and the
  repository's `.devcontainer/<current-folder>/devcontainer.json`. Read both.
  If neither exists, report that devcontainer synchronization is not applicable.
  If only one exists, ask whether to create the missing counterpart.

## 2. Find and update references

- Search for the exact old folder name across repository files, including hidden
  directories such as `.devcontainer` and `.github`. Exclude `.git` internals,
  dependency directories, caches, and build outputs. Do not bypass access
  restrictions. Report any excluded locations that prevent complete verification.
- Inspect matches before changing them. Update relevant repository paths,
  configuration names, scripts, documentation, and notebook source text to the
  new full folder name. Include references outside the hack itself.
- Do not globally replace the bare old number, technology name, or `xxx`.
  Do not rewrite historical records, external URLs, or ambiguous references
  without the author's approval. List any references intentionally retained.
- Use surgical edits. For notebooks, preserve cell IDs, metadata, execution
  counts, outputs, and all unrelated source. Never execute a notebook to rename it.
- Rename the hack folder and its top-level `.devcontainer/<current-folder>`
  counterpart using filesystem moves that preserve their contents. If only the
  letter case changes, use a verified unused intermediate name when required by
  a case-insensitive filesystem.
- Update the top-level devcontainer's `name` and any workspace paths containing
  the old folder name. Preserve its existing mount layout and other settings.
  For example, `/workspace/<old-folder>/Student/Resources` becomes
  `/workspace/<new-folder>/Student/Resources`.

## 3. Synchronize devcontainer configurations

- The top-level `.devcontainer/<new-folder>/devcontainer.json` is authoritative.
- Make `Student/Resources/.devcontainer/devcontainer.json` match its contents,
  including comments and formatting, except omit the top-level `workspaceFolder`
  and `workspaceMount` properties entirely. Do not replace them with empty or
  null values, and do not remove similarly named nested properties.
- Preserve every other property from the authoritative configuration. Do not
  retain student-only extensions, features, startup commands, or open-file lists.
  Summarize any such settings removed by synchronization in the final report.
- These files may contain JSON with comments (JSONC). Preserve valid syntax,
  commas, and comments when removing the workspace properties.

## 4. Verify and report

- Verify that destination folders exist and old folders no longer exist, except
  when no move was needed. Confirm moved files and unrelated edits were retained.
- Repeat the exact-name search in the same scope. Resolve stale local paths and
  list approved retained references or blockers; do not claim a clean search
  when files could not be inspected.
- Validate edited notebooks as JSON and devcontainer files as JSONC, using
  existing tooling when available. Do not launch containers or run provisioning
  commands solely to validate a rename.
- Compare both devcontainer contents: the student version must exactly match
  the top-level version with only its two workspace properties omitted. Confirm
  those properties are absent and that any repository-backed workspace path
  points to the renamed student-resource directory under the configured mount.
- Check affected scripts, links, or configured tests when the rename changes
  their paths. Run a whitespace/error check for the changes.
- Report the final folder name, updated references, configuration synchronization,
  validation results, removed student-only settings, and any remaining issues.
- Do not stage, commit, push, or publish unless the author explicitly requests it.
