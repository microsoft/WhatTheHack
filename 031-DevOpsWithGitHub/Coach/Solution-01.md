# Challenge 01 - Setup Your Repository - Coach's Guide

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

- Some students create their first repository via github desktop.  Make sure students understand how a distributed source control such as git is different from a centralized source control system such as TFVC. 

- To clone a repository via command line: `git clone $URL` in the directory you want to copy the repository to.
  - To get the $URL, go to your repository in github.
  - Select "<> Code" which should be a green button.
  - In the clone section, click on the copy button to get the url.
- Add the files the coaches provided in the same directory.
- In the command line enter: `git add --all` - This will add all of the files you just copied to the folder to be be tracked.
- Now we need to commit our changes by typing `git commit -am "My first commit"`
- Finally we need to push to the remote repository in github by doing `git push -u`.  You may see a warning which will provide the full command if this is the first time you are doing this to target the github server.

## Videos

### Challenge 1 Solution

[![Challenge 1 solution](../Images/WthVideoCover.jpg)](https://youtu.be/8duTFL5fyWg "Challenge 1 solution")
