# Challenge 07 - Azure Repos: Branching & Policies

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction

Now that we have a deployed instance of our code, we are likely going to get a request to add a feature to our code. To this we need to implement a branching strategy. Review the below articles on the basics of a Git branching strategy and the modified version Microsoft uses called Release Flow.

1. [Git Branching Strategy](https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops)
2. [GitHub Flow](https://guides.github.com/introduction/flow/)
3. [Release Flow](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/release-flow)


## Description

In this challenge we will first create a second build pipeline that will build and run unit tests on any code before it gets checked into the master branch. We will also implement a few policies in Azure DevOps to ensure that our team is following the rules. Finally we will make a change to our code to see how branching in Git works. 

- Clone the build pipeline that we created earlier.
   - Remove all but the `restore`, `build` and `test` tasks.
   - Turn off the continuous integration trigger.
- Setup a Branch Policy to protect our `master` branch, [hint](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops). The policy shall: 
   - Require at least 1 reviewer, however, users should be able to approve their own changes (NOTE: you will likely not want to do this in a real app)
   - Require at least 1 linked work item.
   - Perform a `Build validation` using our new build pipeline.
- Using a simple Git Branching strategy let's make a change. 
   - Your manager has asked that you update the name of the site from "Message System" to "Contoso Message System"
   - Create a Work Item requesting we implement the feature. 
   - Make the change in your code. Be sure to make this change on a new "feature branch"
   - Create a Pull Request to merge the change into `master`. Notice how the policies you set are audited on your pull request.
   -  Complete your pull request.

## Success Criteria

1. Verify that the change you made deployed to all three of your environments.
1. Verify that your work item should be in the "closed" state.
1. Show that the branch policies were in place to audit your pull request.
