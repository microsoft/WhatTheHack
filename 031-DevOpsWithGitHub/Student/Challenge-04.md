# Challenge 04 - Your First GitHub Actions Workflow

[< Previous Challenge](Challenge-03.md) - [Home](../README.md) - [Next Challenge >](Challenge-05.md)

## Introduction

Automation is a critical part of an effective DevOps process incorporating elements like CI/CD, but also processes like IssueOps. GitHub Actions provides a platform for GitHub to respond to various event triggers to execute workflows.

Workflows are broken down into jobs that contain the automation steps to complete these jobs. These steps could be a simple CLI command or a pre-defined piece of automation defined as a GitHub Action from GitHub's extensive Marketplace.

Jobs can be run on Linux, Mac or Windows in the cloud on a hosted runner, or run on your own machines through a self-hosted runner. All the challenges today will use hosted runners, but your requirements after today may include the need for self-hosting or a mix of both.

Jobs can be run sequentially or in parallel. Sequential jobs provide the ability to define your workflow sequences, for example the need to build an application, then test it then deploy it. Whereas, parallel jobs allow the ability to scale-out sections of your workflow. For example build your application on x64 at the same time as ARM or, test you application on Chrome at the same time as Firefox.

Common workflows are defined for CI/CD type processes, but the flexibility of GitHub actions to respond to an extensive range of GitHub events enables many other possibilities such as the ability to execute a workflow based on a issue being created in your project.

## Description

This challenge will see us using GitHub Actions to write your first workflow. This workflow will start with a single job triggered by manual event, being expanded on to have a second job and an additional event trigger.

- Create a GitHub workflow in a `.github/workflows` directory (`first-workflow.yml`) that runs manually (*not* triggered by a push or pull request).

- To the workflow add a first job called job1 with two steps within it. The steps should be simple CLI commands to echo out step1 and step2 as applicable

- Trigger the workflow you created to run from GitHub. Check the log file for the workflow run to see your job executed and emitted from the echo statements as expected.

- Add a second job called job2 to your workflow yaml file. In this job add a step, but have this step call a GitHub Action from the GitHub Marketplace. A nice easy and fun example here may be to use something simple like 'Cowsays' which takes an input of a string that it uses to emit an ascii art cow into the workflow logs, however feel free to explore the marketplace for any action that you want to incorporate. 

  **NOTE:** When you look at an Action in the marketplace, note in the Links section on the right the repository link to a public repository with the code that backs that action.

- Execute your workflow again ensuring both jobs run as expected. 
  
  **NOTE:** These jobs have run in parallel.

- Amend your workflow yaml so that job2 will run sequentially after job1 completes. Execute the workflow again to test the sequence.

- Finally amend your workflow yaml file with an additional trigger that will fire when an issue is created.

## Success Criteria

- Be able to execute your first workflow from a manual trigger or an issue being created.
- Be able to see output from all the steps in the two jobs.
- The two jobs run now run sequentially with job2 running after job1 completes.
- job2 successfully runs a GitHub Action from the marketplace

## Learning Resources

- [Understanding GitHub Actions](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/understanding-github-actions)
- [Essential features of GitHub Actions](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/essential-features-of-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Manually trigger a workflow](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- [Events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
- [GitHub Action Variables](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/variables)
- [GitHub Actions Expressions](https://docs.github.com/en/enterprise-cloud@latest/actions/learn-github-actions/expressions)


## Advanced Challenges (optional)
- In your workflow file define an environment variable for your workflow or job with a string in it and pass it into one of your echo steps in job1.

- In your workflow file pass the value from an environment variable into an input of your GitHub Action in job2 

[< Previous Challenge](Challenge-03.md) - [Home](../README.md) - [Next Challenge >](Challenge-05.md)
