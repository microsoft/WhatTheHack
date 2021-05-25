# What The Hack: DevOps with GitHub

## Challenge 4 - Continuous Integration (CI)

[< Previous](challenge03.md) - [Home](../readme.md) - [Next >](challenge05.md)

### Introduction

With our existing repository and newly-created Azure App Service, we have laid the foundation for our application. Now, we must connect our source code and its destination. The first step in this journey is called Continuous Integration (CI). 

Continous integration is the process of merging local code changes into source control and may include steps to automatically build and/or test the code. When done effectively, Continuous Integration allows developers to rapidly iterate and collaborate, and it helps ensure that newly added code does not break the current application. 

Review the following articles:
- [About continuous integration](https://docs.github.com/en/actions/building-and-testing-code-with-continuous-integration/about-continuous-integration)
- [Setting up continuous integration using workflow templates](https://docs.github.com/en/actions/building-and-testing-code-with-continuous-integration/setting-up-continuous-integration-using-github-actions)

### Challenge

In this challenge, you will build and test the .NET Core application.

1. Create a new `.NET Core` workflow from the GitHub Actions marketplace. In your repo, click on Actions in the top menu > New Workflow (button) > scroll down to the 'Continuous integration workflows' section and setup the '.NET Core' action.

2. Review the layout of the workflow. There is a single job (named 'build') with multiple steps (restore, build, test).

3. In your workflow, under the "Setup .NET Core" step, change the .NET version to `2.2` to match the version defined by the application.

4. Configure path filters to *only* trigger this workflow for changes in the `/Application` folder.

5. Configure the workflow to trigger on pushes *and* pull requests.

6. Update the predefined steps used to build the .NET Core application (note: for each step below, you will need to update each command to pass the relative path to the  `.csproj` as an argument):
   - `restore` - will get all the dependencies. Update with an [argument](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build#arguments) to the application csproj file.
   - `build` - will actually compile our code. Update with an argument to the application csproj file.
   - `test` - will execute all our unit tests. Update with an argument to the unit test csproj file. 

7. Test the workflow by making a small change to the application code (i.e., add a comment). Commit, push and ensure the workflow completes successfully.

At this point, any changes pushed to the `/Application` folder automatically triggers the workflow...and that is Continuous Integration! 

### Success Criteria

- Any changes pushed to the `/Application` folder automatically triggers the workflow 
- .NET Core restore, build and test steps completes successfully

### Learning Resources

- [Introduction to GitHub Actions](https://docs.github.com/en/free-pro-team@latest/actions/learn-github-actions/introduction-to-github-actions)
- [.NET Core Action to build and test](https://github.com/actions/starter-workflows/blob/dacfd0a22a5a696b74a41f0b49c98ff41ef88427/ci/dotnet-core.yml)
- [Understanding workflow path filters](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths)
- [dotnet commands](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet#dotnet-commands)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

### Tips

- If you are having trouble finding a starting point, try clicking over to the 'Actions' tab of your GitHub repository. 
- Take advantage of the prebuilt workflow templates if you find one that might work! 

### Advanced Challenges (optional)

1. In this challenge, if the workflow fails, an email is set to the repo owner. Sometimes, you may want to log or create a GitHub issue when the workflow fails.
    - Add a step to your workflow to create a GitHub issue when there is a failure.

[< Previous](challenge03.md) - [Home](../readme.md) - [Next >](challenge05.md)