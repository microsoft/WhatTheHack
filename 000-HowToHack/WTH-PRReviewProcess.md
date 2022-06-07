# What The Hack – Pull Request Review Process

## Introduction
Thank you for helping review content for What The Hack. Reviewing a Pull Request is a key way of contributing to the project by ensuring we have good quality content. 

For a Pull Request, you may be:
- Assigned as a PR owner and reviewer
- Requested to be a reviewer

The review process below is the same whether you are a reviewer or assigned as the PR owner. The assigned PR owner has a couple of extra responsibilities.

### Pull Request Owner

If you are assigned as the Pull Request owner, you will be responsible for shepherding the content in the PR through the review process until it is either approved to be merged into the What The Hack repo, or decided that it does not make a good fit.

The What The Hack repo has a policy on its ‘master’ branch requiring:
- All contributions to be made via a Pull Request.
- **Two** reviewers must give an “approval” review before the PR can be merged (published) into the WTH repo.

The Pull Request may need to go through a couple of review cycles with the PR content’s author(s) and other reviewers. As the owner of the PR, you will be responsible for:
- Communicating with the author(s) of the content so they know what to expect during the review process.
- Requesting additional reviewers who need to review the content.
- Coordinating with the other reviewers to ensure they are each reviewing the content sequentially. Multiple reviewers should not review the same content at the same time to avoid possibly requesting the same changes.
- Notifying the author(s) when a review pass has been completed so they can take action on any requested changes.
- Notifying the other reviewers when requested changes have been made so they can re-review and approve.

**NOTE:** Both authors and reviewers should be notified by GitHub itself anytime someone comments on or requests a change in a PR, however, those notifications may end up in a Junk or Spam folder. The PR owner should reach out directly to both reviewers and authors to keep the process moving along.

### Pull Request Reviewers

Reviewers should always be on the lookout for the common issues for all PRs:
- Verify that file/folder structure match the WTH templates & all navigation links work
- Verify that Student & Coach content remains separate (i.e. No links to the WTH repo from student guide!)
- Verify no grammar/spelling/template consistency issues

## Pull Request Types

There are three common categories of Pull Requests:
- New Hack
- Hack Update - Original author(s)
- Hack Update - New contributor(s)

### New Hack

A Pull Request for new hack gets a high level of scrutiny by all members of the WTH vTeam during the review process. As per our contribution guide, the WTH vTeam should be working with the author(s) as they develop a new hack. 

When the author(s) believe the content is ready, the WTH vTeam should set up an "offline" review to go through the content **BEFORE** it is submitted via a Pull Request. This will give the author(s) an opportunity to receive feedback ***privately*** and take action on it before submitting a PR. This will also help reduce the number of review cycles to a minimum once the PR is submitted.

**NOTE:** All comments, change requests, revisions, and feedback shared on a Pull Request on GitHub are publicly visible.

### Hack Update – Original Author(s)

A Pull Request from an original author to update his/her/their hack should be the easiest type of PR to review. Updates by the original author(s) will get less scrutiny and are generally “rubber stamped” if they are minor in nature.

The bigger the update, the more the reviewer should always be on the lookout for the common structural and template issues listed above.

### Hack Update – New Contributor(s)

A Pull Request to update a hack from a contributor who is not one of the original authors should get slightly more scrutiny. The assigned owner of the PR is responsible for bringing the original author(s) into the review process. 

As the subject matter expert, the original author(s) should be instructed to review the updated content with a focus on technical accuracy. 

All other reviewers should review the update for the common structural and template issues listed above.

## How To Work with Pull Requests in GitHub

If you're new to GitHub, here is a quick guide on how to handle the Pull Request review process on the GitHub website. The steps below illustrate how to do a single review pass. 

**NOTE:** You may repeat this process multiple times if you, or any other reviewer, requests the author(s) to make changes. Each time the author(s) makes a change, you would need to repeat these steps to review that the changes satisfy your request.

1.	Open the Pull Request link in GitHub.
1.	The policy on the WTH repo is that every PR needs at least **two** “approving reviews” before it can be merged into the WTH repo.
**NOTE:** To "merge” means to publish the contents/changes contained in the PR into the WTH repo. 
If you are the first one to start a review on a PR, you will see the following on the right side:

    ![Sample PR Single Reviewer](./images/wth-pr-singlereviewer.png?raw=true "Example PR Single Reviewer")
1.	You should add a second person to be a reviewer for this PR. To add an additional reviewer, click on the word “Reviewers” as-in the first screenshot below. Then, you may type in the desired reviewer’s name or GitHub handle in the drop down box as demonstrated in the second screen shot below.

    ![Add PR Reviewer - Part 1](./images/wth-pr-addreviewer-01.png?raw=true "Add PR Reviewer 1")
    ![Add PR Reviewer - Part 2](./images/wth-pr-addreviewer-02.png?raw=true "Add PR Reviewer 2")
1.	To view the author's content and see it in the web browser, open his/her/their branch by right-clicking on the link to it as shown in the screenshot below. It is a good idea to open it in a separate browser window, side-by-side with the PR itself. 
![Open PR Content](./images/wth-pr-opencontent.png?raw=true "Open PR Content")
1.	There are TWO ways to start a “review” of a PR in GitHub. Both require you to navigate to the “Files Changed” tab first. This will show you a list of all the files that were changed and their contents. Red lines represent things changed/removed and the accompanying green lines are what replaced it. 
![PR Files Changed Tab](./images/wth-pr-fileschangedtab.png?raw=true "PR Files Changed Tab")
    1. Start a review by making in-line comments – Click the blue “plus” symbol that appears when you mouse over the line number to bring up the comment dialog window.  This is how you will normally start the review as you leave feedback or request changes in specific places in the content. 
    ![PR In-line Comments](./images/wth-pr-inlinecomments.png?raw=true "PR In-line Comments")
    1. Start a review from the “Review Changes” button at the top of the “Files Changed” tab.  If you are not requesting any changes or just want to leave a single comment, you would start (and finish) the review this way.
    ![PR Review Changes Button](./images/wth-pr-reviewchangesbutton.png?raw=true "PR Review Changes Button")
1.	Do your review!  Follow the guidelines from the [WTH Author’s Guide](https://aka.ms/wthauthor) for help and be on the look out for the common issues:
    1.	Folder Structure/File organization/Navigation links/etc
    1.	Links from Student guide to the WTH repo
    1.	Grammar/spelling/template consistency
1.	When you are done making in-line comments or if you want to make only a single comment, click the “Review Changes” button at the top of the “Files Changed” tab.  You need to select one of the three options: Comment, Approve, or Request Changes. 
![PR Comment Approve or Request Changes](./images/wth-pr-comment-approve-changes.png?raw=true "PR Comment Approve or Request Changes")  
    1.	If you choose “Comment”, your comment will be added to the conversation tab of the PR, but the review will not be completed.
    1.	If you choose “Request Changes”, you are indicating that the PR can NOT be merged UNTIL the author takes an action to make the change you requested.  The author should be notified automatically by GitHub. However, it’s a good practice to reach out to the author on Teams or email to let them know it is their action to implement the change(s) you requested.
    1.	If you choose “Approve”, this does NOT merge/publish the PR into the WTH repo.  This only indicates that as a reviewer, YOU “approve” the changes.  It takes TWO reviewers to APPROVE before the “Merge pull request” button lights up green.  Thus, if you are the first reviewer, you will not be able to merge the PR.  
    ![PR With A Single Approval](./images/wth-pr-singleapproval.png?raw=true "PR With a Single Approval") 
1.	Once you have completed your initial review, reach out to the second reviewer to make sure they know to complete their review.

    If the second (or any other) reviewer has requested changes, it is the responsibility of the assigned owner of the PR to reach out to the author(s) to let them know it is their action to make the changes requested by the second (or any other) reviewer.

    **NOTE:** If the PR has a lot of changes, it is a good practice for the assigned PR owner to coordinate with all reviewers to let them have a chance to review and request changes before reaching out to the author(s) to let the author(s) know they have an action.
1.	The steps above shall be repeated until all reviewers have “approved” the changes. When all reviews are complete and “approved’, the “Merge pull request” button will light up green, and it’s up to assigned PR owner to have the honor of mashing the big green button! 😊

    At this point, the PR is “closed” and the assigned task is complete.
