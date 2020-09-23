# What The Hack - Solution 00

# Challenge \0: Coach's Guide \\Pre-requisites - Ready, Set, GO!

**[Home](../readme.md)** - [Next Challenge>](./Solution01.md)

## Notes & Guidance
# Pre-event: Lab Environment Setup
- This hack will require a centralized environment to host a FHIR server that is prepopulated with patient data.
- We will be using the new Azure API for FHIR managed service and then populating it with dummy data.
- Install the Azure CLI if you haven’t already.
    - For windows OS, use bash shell in Windows Subsystem for Linux (see WLS install under tool-set below)
- Install ‘jq’ for your version of Linux/Mac/WSL:
    - brew install jq
    - sudo apt install jq
    - sudo yum install jq
    - sudo zypper install jq
    - If you see jq not found errors, make sure you’ve updated all your packages.
- Install the latest version of nodejs (at least 10.x) on your machine, if using Windows, use the bash shell in the Windows Subsystem for Linux

