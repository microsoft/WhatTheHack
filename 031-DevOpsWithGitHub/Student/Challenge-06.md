# Challenge 06 - Continuous Integration (CI)

[< Previous Challenge](Challenge-05.md) - [Home](../README.md) - [Next Challenge >](Challenge-07.md)

## Introduction

With our Azure resources created we have laid the foundations resources for our application. Now, we must connect our source code and its destination. The first step in this journey is called Continuous Integration (CI). 

Continuous integration is the process of merging local code changes into source control and may include steps to automatically build and/or test the code. When done effectively, Continuous Integration allows developers to rapidly iterate and collaborate, and it helps ensure that newly added code does not break the current application. 

Review the following articles:
- [About continuous integration](https://docs.github.com/en/actions/building-and-testing-code-with-continuous-integration/about-continuous-integration)
- [Setting up continuous integration using workflow templates](https://docs.github.com/en/actions/building-and-testing-code-with-continuous-integration/setting-up-continuous-integration-using-github-actions)

## Description

In this challenge, you will build and test the .NET Core application.

- Create a new `.NET` workflow. 

   **NOTE:** To get a new scaffold workflow, in your repo click on Actions in the top menu > New Workflow (button) > scroll down to the 'Continuous integration workflows' section and select the configure button on the '.NET' example.

- Review the layout of the workflow. There is a single job (named 'build') with multiple steps (restore, build, test). 

   **NOTE:** There are some new events for the workflow we haven't used before for 'push' and 'pull_request'.

- In your workflow, under the "Setup .NET Core" step, check the .NET version is `6.0.x` to match the version defined by the application.

- Ensure the workflow is configured to trigger on both pushes *and* pull requests.

- Configure both these triggers with path filters to *only* trigger this workflow for changes in the `/Application` folder.

- Update the predefined steps used to build the .NET Core application 

   **NOTE:** For each step below, you will need to update each command to pass the relative path to the  `.csproj` as an argument):
   - `restore` - will get all the dependencies. Update with an [argument](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build#arguments) to the application csproj file.
   - `build` - will actually compile our code. Update with an argument to the application csproj file.
   - `test` - will execute all our unit tests. Update with an argument to the unit test csproj file. 

- Test the workflow by making a small change to the application code (i.e., add a comment). Commit, push and ensure the workflow completes successfully.

At this point, any changes pushed to the `/Application` folder automatically triggers the workflow...and that is Continuous Integration! 

## Success Criteria

- Any changes pushed to the `/Application` folder automatically triggers the workflow 
- .NET Core restore, build and test steps completes successfully

## Learning Resources

- [Introduction to GitHub Actions](https://docs.github.com/en/free-pro-team@latest/actions/learn-github-actions/introduction-to-github-actions)
- [.NET Core Action to build and test](https://github.com/actions/starter-workflows/blob/dacfd0a22a5a696b74a41f0b49c98ff41ef88427/ci/dotnet-core.yml)
- [Understanding workflow path filters](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)
- [dotnet commands](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet#dotnet-commands)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

## Tips

- If you are having trouble finding a starting point, try clicking over to the 'Actions' tab of your GitHub repository. 
- Take advantage of the prebuilt workflow templates often will save you a ton of work! 

## Advanced Challenges (optional)

- In this challenge, if the workflow fails, an email is set to the repo owner. Sometimes, you may want to log or create a GitHub issue when the workflow fails.
    - Add a step to your workflow to create a GitHub issue when there is a failure.

[< Previous Challenge](Challenge-05.md) - [Home](../README.md) - [Next Challenge >](Challenge-07.md)
