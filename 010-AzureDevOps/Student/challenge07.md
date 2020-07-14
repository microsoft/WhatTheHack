# What the Hack: DevOps 

## Challenge 7 – Azure Repos: Branching & Policies
[Back](challenge06.md) - [Home](../readme.md) - [Next](challenge08.md)

### Introduction

Now that we have a deployed instance of our code, we are likely going to get a request to add a feature to our code. To this we need to implement a branching strategy. Review the below articles on the basics of a Git branching strategy and the modified version Microsoft uses called Release Flow.

1. [Git Branching Strategy](https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops)
2. [GitHub Flow](https://guides.github.com/introduction/flow/)
3. [Release Flow](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/release-flow)


### Challenge

In this challenge we will first create a second build pipeline that will build and run unit tests on any code before it gets checked into the master branch. We will also implement a few policies in Azure DevOps to ensure that our team is following the rules. Finally we will make a change to our code to see how branching in Git works. 

1. Clone the build pipeline that we created earlier.
   1. Remove all but the `restore`, `build` and `test` tasks.
   2. Turn off the continuous integration trigger.
2. Setup a Branch Policy to protect our `master` branch, [hint](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops). The policy shall: 
   1. Require at least 1 reviewer, however users should be able to approve their own changes (NOTE: you will likely not want to do this in a real app)
   2. Require at least 1 linked work item.
   3. Perform a `Build validation` using our new build pipeline.
3. Using a simple Git Branching strategy lets make a change. 
   1. Your manager has asked that you update the copyright information at the bottom of the site, currently it says `© ASP.NET Core` and it should say `© 2019 Contoso Corp.`
   2. Create a Work Item requesting we implement the feature. 
   3. Make the change in your code. Be sure to make this change on a new "feature branch"
   4. Create a Pull Request to merge the change into `master`. Notice how the policies you set are audited on your pull request.
   5.  Complete your pull request.

### Success Criteria

1. You should see the change you made deployed to all three of your environments.
2. Your work item should be in the "closed" state.


[Back](challenge06.md) - [Home](../readme.md) - [Next](challenge08.md)
