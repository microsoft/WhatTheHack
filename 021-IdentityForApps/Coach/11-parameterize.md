# Challenge \#11 - Parameterize Your Policies

[< Previous Challenge](./10-appinsights.md) - **[Home](./README.md)** - [Next Challenge>](./12-monitor.md)
## Introduction

This challenge will have the team use the VS Code Azure AD B2C extension to create environment settings for their custom policy files. By parameterizing their policy files, the same files can be used to create dev/test and production files that can be deployed to different B2C tenants.

Also, by parameterizing these policy files, the team can also enable token replacement in a CICD pipeline tool, like Azure DevOps Pipelines or GitHub Actions.


## Hackinfo

1. The team will first install the VS Code Azure AD B2C extension, if they have not done so already
2. Then they will begin to extract values into the settings file that will differ between environments
3. The team will create separate settings for Prod and Dev/Test (or more if they want)
4. The team will then demonstrate they can chnage a setting file and then regenerate their environment's B2C policy files.

