# Challenge 09: Branching & Policies - Coach's Guide

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)** - [Next Solution >](./Solution-10.md)

## Notes & Guidance

- Branch protection rules
    - In your repository, go to "Settings"
    - Select "Branches" on the left hand side.
    - Select "Add Rule"
    - For branch pattern enter the default branch such as main or master
    - Check "Require a pull request before merging" and select "Require review from Code Owners"
    - Select "Create"
- The following is needed to run during the pull request and only for the application path:
```
  pull_request:
    branches: [ main ]
    paths: Application/**
```
- Codeowners
    - A new file at the root of the repo is needed called "CODEOWNERS", you will need to define the path and the owner.  
        - `/Application/ @whowong`

