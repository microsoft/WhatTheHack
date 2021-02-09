# What The Hack: DevOps with GitHub

## Challenge 2 - Repositories

[< Previous](challenge01.md) - [Home](../readme.md) - [Next >](challenge03.md)

### Introduction

Historically, version control has been the first component that teams implement as they start on a project. It is one of the oldest and most well understood components of DevOps. Version control systems allow developers to colloborate and simulataneously contribute to the same codebase. They can also help teams track versions (so code can be rolled back if bad changes are made) and track bugs, work, and testing by the team. Please take a moment to review the [Git handbook](https://guides.github.com/introduction/git-handbook/) to understand the basics of version control, focusing on the distributed version control technology, Git.

### Challenge

Now that we have a basic understanding of version control and Git, lets get some code checked into source control. DevOps best practices can apply to any programming language, so for today we have provided you a simple .NET Core web application to use.

1. Begin by cloning the GitHub repository you created in the [first challenge](challenge01.md) to your local computer ([hint](https://help.github.com/en/articles/cloning-a-repository)).

2. Next, obtain the code (sample application and ARM template) from the Resource files provided by your coach.

3. Finally, commit the files to your GitHub repository using your preferred Git client.

### Success Criteria

- Your repo is cloned to your local machine and sync'd with GitHub.com
- The "Application" and "ArmTemplates" folders are at the root of your repository

### Learning Resources

- Cloning a repository via the [command line](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) or [GitHub Desktop](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/cloning-a-repository-from-github-to-github-desktop)
- For those using GitHub Desktop, here is documentation on [commiting](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/committing-and-reviewing-changes-to-your-project) and [pushing](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/pushing-changes-to-github) changes to a repository.
- If working with the command line, check out these articles on [commiting](https://docs.github.com/en/github/committing-changes-to-your-project/creating-and-editing-commits) and [pushing](https://docs.github.com/en/github/using-git/pushing-commits-to-a-remote-repository) changes.
- Additionally, you may need to pull other people's changes into your local repository to stay in sync--see documentation for [command line](https://docs.github.com/en/github/using-git/getting-changes-from-a-remote-repository) and [GitHub Desktop](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/keeping-your-local-repository-in-sync-with-github).

### Tips

- For a concise explanation of adding files to a repository via the command line, see [here](https://docs.github.com/en/github/managing-files-in-a-repository/adding-a-file-to-a-repository-using-the-command-line). 
- To see how it's done in the GitHub portal, check [here](https://docs.github.com/en/github/managing-files-in-a-repository/managing-files-on-github). 

### Advanced Challenges (optional)

In this challenge, we successfully added code to our repository! However, version control is about more than pushing code to a centralized location--it is critical in keeping developers in sync with changes made by anyone. Thus, we care not only about *pushing* code up to our repository, but also *pulling* changes down from it. 

To practice this, have another member of the team clone the repository to their local machine (or pull the new changes if already cloned). Let this person make a small change of their own to one of the files (perhaps adding a comment or a newline). Then, push the change back to GitHub. The rest of the team should then pull the change, to ensure they see it on their local machines. (See some of the above links on adding files and syncing changes if you get stuck). 

[< Previous](challenge01.md) - [Home](../readme.md) - [Next >](challenge03.md)
