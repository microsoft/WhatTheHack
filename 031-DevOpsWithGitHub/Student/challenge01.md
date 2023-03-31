# Challenge 01 - Setup Your Repository

[< Previous Challenge](Challenge-00.md) - [Home](../README.md) - [Next Challenge >](Challenge-02.md)

## Introduction

Historically, version control has been the first component that teams implement as they start on a project. It is one of the oldest and most well understood components of DevOps. Version control systems allow developers to collaborate and simultaneously contribute to the same codebase. They can also help teams track versions (so code can be rolled back if bad changes are made) and track bugs, work, and testing by the team. Please take a moment to review the [Git handbook](https://guides.github.com/introduction/git-handbook/) to understand the basics of version control, focusing on the distributed version control technology, Git.

## Description

In this challenge, you will ensure that you have a GitHub repo set up with the sample application code in it. There are two scenarios your coach may decide to use for this challenge:

- Create a new GitHub Repo and Commit the Sample Application Files
- Use an Existing GitHub Repo with the Sample Application Files

Follow the instructions below only for the scenario your coach instructs you:

## Create a new GitHub Repo and Commit the Sample Application Files

Now that we have a basic understanding of version control and Git, lets get some code checked into source control. DevOps best practices can apply to any programming language, so for today we have provided you a simple .NET Core web application to use.

If we were not supplied a repository in the next few steps you will need to create a repository and commit the supplied hackathon resource files into your repository supplied by your coach.

- Create a new repo for the hackathon. This is where you work during the event

- Begin by cloning the GitHub repository you created in the previous step to your local computer ([hint](https://help.github.com/en/articles/cloning-a-repository)).

- Next, obtain the code (sample application and ARM template) from the Resource files provided by your coach.

- Finally, commit the files to your GitHub repository using your preferred Git client.

## Use an Existing GitHub Repo with the Sample Application Files

Your coach will provide you the URL to an existing repo with the sample application code already in it and add you to this repo as a contributor.

DevOps best practices can apply to any programming language, so for today we have provided you a simple .NET Core web application to use.

- Begin by cloning the GitHub repository provided by your coach to your local computer ([hint](https://help.github.com/en/articles/cloning-a-repository)).

## Success Criteria

- Your repo is cloned to your local machine and sync'd with GitHub.com
- The `Application` and `ArmTemplates` folders are at the root of your repository

## Learning Resources

- Cloning a repository via the [command line](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) or [GitHub Desktop](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/cloning-a-repository-from-github-to-github-desktop)
- For those using GitHub Desktop, here is documentation on [commiting](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/committing-and-reviewing-changes-to-your-project) and [pushing](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/pushing-changes-to-github) changes to a repository.
- If working with the command line, check out these articles on [commiting](https://docs.github.com/en/github/committing-changes-to-your-project/creating-and-editing-commits) and [pushing](https://docs.github.com/en/github/using-git/pushing-commits-to-a-remote-repository) changes.
- Additionally, you may need to pull other people's changes into your local repository to stay in sync--see documentation for [command line](https://docs.github.com/en/github/using-git/getting-changes-from-a-remote-repository) and [GitHub Desktop](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/keeping-your-local-repository-in-sync-with-github).

## Tips

- For a concise explanation of adding files to a repository via the command line, see [here](https://docs.github.com/en/github/managing-files-in-a-repository/adding-a-file-to-a-repository-using-the-command-line). 
- To see how it's done in the GitHub portal, check [here](https://docs.github.com/en/github/managing-files-in-a-repository/managing-files-on-github). 

## Advanced Challenges (optional)

In this challenge, we have code in our repository! Version control is about more than pushing code to a centralized location--it is critical in keeping developers in sync with changes made by anyone else on your team. Thus, we care not only about *pushing* code up to a repository, but also *pulling* changes down from it. 

To practice this, have another member of the team clone the repository to their local machine (or pull the new changes if already cloned). Let this person make a small change of their own to one of the files (perhaps adding a comment or a newline). Then, push the change back to GitHub. The rest of the team should then pull the change, to ensure they see it on their local machines. (See some of the above links on adding files and syncing changes if you get stuck). 

[< Previous Challenge](Challenge-00.md) - [Home](../README.md) - [Next Challenge >](Challenge-02.md)
