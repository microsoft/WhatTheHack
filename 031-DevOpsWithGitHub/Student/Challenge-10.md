# Challenge 10 - Security

[< Previous Challenge](Challenge-09.md) - [Home](../README.md) - [Next Challenge >](Challenge-11.md)

## Introduction

Our application is up and running! We are even using a proper Git Flow to protect against unintended changes to our main branch, and we are recording application telemetry into App Insights. Before we are truly production ready, though, there is one topic we have to cover--security. 

One good DevOps practice is to enable protections against code-level vulnerabilities, and GitHub provides a number of useful features in this area. First, there are Issues, which allow developers or users to open 'tickets' indicating bugs to be fixed or potential vulnerabilities. If your organization prefers security flaws to be reported in a location other than GitHub, you have the option to provide a custom Security policy which describes the process for reporting. 

In addition to these manual processes, GitHub also provides automated tools for scanning code for common errors. In this challenge, you will utilize the built in Dependabot which provides alerts if your repository contains libraries, packages, or external dependencies with known vulnerabilities. You will also set up a workflow with CodeQL which can scan your source code for common coding errors or basic security flaws.

## Description

In this challenge, you will improve the security of your repository using some of GitHub's built-in tools. 

- Find the repository's Security policy. If there is an existing policy, make an edit and merge your change back into the main branch. Otherwise, go ahead and create a policy using the template provided. GitHub Security policies are Markdown documents that indicate the preferred way to report security vulnerabilities for the repository. 

- Enable Dependabot alerts for the repository. Dependabot is an automated tool that creates a pull request when any dependencies in the code base has a known vulnerability. 

- Finally, set up and run a Code scanning workflow for the repository using GitHub's 'CodeQL Analysis.' This workflow can run either on each pull request or on a schedule, and it checks your code for common vulnerabilities or errors. 

## Success Criteria

- In GitHub, you should be able to view the 'closed' pull request which either created or updated the Security policy (SECURITY.md file). 
- Additionally, you should be able to view a new 'open' pull request created by Dependabot requesting an update of a dependency. 
- Finally, you should be able to view the results of the CodeQL Analysis in the Security tab. 

## Learning Resources

- Learn more about adding a security policy to your repository [here](https://docs.github.com/en/github/managing-security-vulnerabilities/adding-a-security-policy-to-your-repository).
- Learn more about Dependabot and vulnerable dependencies [here](https://docs.github.com/en/github/managing-security-vulnerabilities/managing-vulnerabilities-in-your-projects-dependencies).
- Learn more about automated code scanning and understanding results [here](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code).


## Tips

- If you are stuck, check out the 'Security' tab of your repository on GitHub.

[< Previous Challenge](Challenge-09.md) - [Home](../README.md) - [Next Challenge >](Challenge-11.md)

