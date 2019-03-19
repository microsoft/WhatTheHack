# What the Hack: DevOps 

## Challenge 6 – Azure Repos: Branching & Policies
[Back](challenge05.md) - [Home](../../readme.md) - [Next](challenge07.md)

### Introduction

1. [Git Branching Strategy](https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops)
2. [Release Flow](https://docs.microsoft.com/en-us/azure/devops/learn/devops-at-microsoft/release-flow)


### Challenge

1. Clone the build pipeline that we created earlier.
   1. Remove all but the `restore`, `build` and `test` tasks.
   2. Turn off the continous intergration trigger.
2. Setup a Branch Policy to protect our `master` branch, [hint](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops). The policy shall: 
   1. Requrie at least 1 reviewer, however users should be able to approve their own changes.
   2. Require at least 1 linked work item.
   3. Perform a `Build validation` using our new build pipeline.
3. Using a simple Git Branching strategy lets make a change. 
   1. Your manager has asked that you update the copyright information at the bottom of the site, currently it says `© ASP.NET Core` and it should say `© 2019 Contoso Corp.`
   2. Create a Work Item requesting we implment the feature. 
   3. Make the change in your code. Be sure to make this change on a new "feature branch"
   4. Create a Pull Request to merge the change into `master`. Notice how the policies you set are audited on your pull request.
   5.  Complete your pull request.

### Success Criteria

1. You should see the change you made deployed to your `ingergration` site.
2. Your work item should be in the "closed" state.


[Back](challenge05.md) - [Home](../../readme.md) - [Next](challenge07.md)
