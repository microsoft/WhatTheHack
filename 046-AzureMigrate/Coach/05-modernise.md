# Challenge 5: Modernise - Coach's Guide

[< Previous Challenge](./04-migrate.md) - **[Home](./README.md)**

## Notes and Guidance

- Consider these challenges as stretch, if there is any time remaining
- You could let the participant choose one of the options, if there are no times for all

## Solution Guide

- The Data Migration Assistant is pre-installed in the SQL Server nested VM (smarthotelsql1), but it is an old version. When you start it up, it will try to auto-aupgrade, but it will fail because the .NET 4.8 runtime is not installed. Download this prerequisite, and try to run (and autoupgrade) the Data Migration Assistant tool again