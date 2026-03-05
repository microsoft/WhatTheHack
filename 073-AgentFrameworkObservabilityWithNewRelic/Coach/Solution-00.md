# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

A GitHub account, GitHub Copilot, and VS Code is all that is needed for this hack.  All are free and GitHub Copilot if needed has a free 30 day trial.

- [Create GitHub Account](https://github.com/join)
- [Install Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [Install GitHub Copilot in VS Code](https://docs.github.com/en/copilot/quickstart?tool=vscode)

---

## Common Issues & Troubleshooting

### Issue 1: GitHub Codespaces Not Starting

**Symptom:** Codespace hangs on "Setting up your codespace" or fails to load
**Cause:** Browser extensions, network issues, or account permissions
**Solution:**

- Try incognito/private browsing mode
- Clear browser cache and cookies
- Verify GitHub account has Codespaces enabled
- Check [GitHub Status](https://www.githubstatus.com/) for outages

### Issue 2: VS Code Extensions Not Installing

**Symptom:** Extensions fail to install or show errors
**Cause:** Network restrictions, proxy settings, or corrupted cache
**Solution:**

- Check network connectivity
- Try installing from VS Code Marketplace website
- Clear VS Code extension cache: `~/.vscode/extensions`
- Restart VS Code

### Issue 3: Environment Variables Not Set

**Symptom:** API calls fail with authentication errors
**Cause:** `.env` file missing or not loaded
**Solution:**

- Verify `.env` file exists in project root
- Check variable names match expected format
- Restart terminal/Codespace after changes
- Use `echo $VARIABLE_NAME` to verify values

---

## What Participants Struggle With

- **Understanding Codespaces:** Help them understand it's a cloud-hosted VS Code environment with all tools pre-installed
- **API Key Setup:** Guide them through obtaining and setting GitHub token and New Relic license key
- **Environment Variables:** Watch for participants putting keys directly in code instead of `.env` file
- **Git/GitHub Basics:** Some may need help with basic git commands and GitHub navigation

---

## Time Management

**Expected Duration:** 30 minutes
**Minimum Viable:** 15 minutes (for experienced developers with existing accounts)
**Stretch Goals:** +15 minutes (for those needing to create new accounts or troubleshoot)

---

## Validation Checklist

Coach should verify participants have:

- [ ] GitHub account created and logged in
- [ ] VS Code or Codespaces running successfully
- [ ] Can create and edit files in the workspace
- [ ] New Relic account created and logged in
- [ ] Environment variables configured in `.env` file
