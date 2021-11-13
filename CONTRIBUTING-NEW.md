# Contribution Guidelines

Thank you for your interest in What The Hack!

Contributions come in many forms: submitting issues, improving an existing hack, and of course developing new hacks.

This document provides the guidelines for how to contribute to the What The Hack project.

## Issues

The primary way to engage and get in touch with the What The Hack team is to submit an issue via Github. This section describes the guidelines for submitting issues.

### Issue Types

There are 5 types of issues:

- Issue/Bug: You've found a bug in a hack and want to report it, create an issue to track the bug.
- Issue/Discussion: You have a suggestion on how to improve an existing hack.
- Issue/Proposal: Used to propose a new hack. This will get the What The Hack team to engage with you and plug you into our contribution process.
- Issue/Request: Want help hosting a WTH event? WTH content is self-serve, but we're happy to meet with you and walk you through how to do it.
- Issue/Report: Want to share with us that you hosted a WTH event? We'd love to know how and where WTH content is being used. Give us your feedback, and let us know!

### Before You File

Before you file an issue, make sure you've checked the following:

1. Check for existing issues
    - Before you create a new issue, please do a search in [open issues](https://github.com/microsoft/WhatTheHack/issues) to see if the issue or feature request has already been filed.
    - If you find your issue already exists, make relevant comments and add your [reaction](https://github.com/blog/2119-add-reaction-to-pull-requests-issues-and-comments). Use a reaction:
        - 👍 up-vote
        - 👎 down-vote
1. For bugs
    - You have as much data as possible. Let us know which hack has the bug. Is it in the Student guide? Coach guide? Is it a documentation issue? Or an issue with a provided resource file or solution file?
1. For proposals
    - Is this a net new hack topic, or should your contribution extend or modify and existing hack?
    - It is okay to have more than one hack on the same technology, but the new hack should be an independent set of challenges that stand on their own.

## Contributing to What The Hack

This section describes the guidelines for contributing to What The Hack.

In general, the WTH team prefers to collaborate with and assist contributors as they author new hacks. This makes the review process smoother when a new hack is ready to be published via a Pull Request. We offer the option of collaborating via Microsoft Teams in a "What The Hack" team that we maintain at Microsoft. 

You may still choose to develop a new hack independently and submit it for review via the [PR process below](#use-work-in-progress-prs-for-early-feedback).

### On-Boarding Process (Optional, but STRONGLY recommended)

Once you have submitted an [Issue/Proposal](https://aka.ms/wthproposal) via Github, you can expect the following:

1.	The WTH team will get in touch to start the on-boarding process. If they are aware of other authors with similar proposals, they will schedule a meeting with everyone to see if it makes sense to combine efforts.
1.	The WTH team will add you and any co-authors to the "What The Hack" team in Microsoft Teams and:
    - Create a new channel for you with the name of your proposed hack. 
        - You can use this channel to communicate with the WTH team and collaborate with any co-authors.
    - Add a copy of the "[WTH Outline Template](https://github.com/microsoft/WhatTheHack/blob/master/000-HowToHack/WTH-ProposalAndAbstract.docx?raw=true)" to the Files tab of your new channel. 
        - You can use this Word template to brainstorm and draft an outline of your hack.
1.	The WTH team will schedule a kick off call with you and any co-authors to:
    - Review the WTH contribution process and set expectations for collaboration between the WTH team and the author(s).
    - Walk through the [WTH Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md). 
        - All authors need to read and internalize this document to save you trouble and heartache down the line.
    - Set up a bi-weekly cadence meeting to check-in and address any questions or requests you have during development.
1.	During the cadence meetings, the authors will dictate the pace of the call and report what they have worked on. It is essentially your time to discuss things with the WTH team and/or collaborate with your co-authors. If there is a stint that nothing was worked on, that’s totally fine. We understand and appreciate that most folks are contributing to What The Hack in their spare time!

**NOTE:** If you are not familiar with Git, Github, or markdown files, you are not alone! Since What The Hack is a collection of mostly course content and documentation, many of our contributors are not developers. It's out of scope to explain these tools here. However, there are plenty of great [resources on the Internet](https://docs.github.com/en/get-started/quickstart/contributing-to-projects) that can help get you up to speed. Also, don't be shy to ask the WTH team for help navigating Git & Github. 

### Development Process

All contributions to the What The Hack repo come through pull requests. This means that development of a hack starts by forking the What The Hack repo into your own Github account. This is where you will do your work. Eventually, you will create a pull request to submit your work back to the What The Hack repo for review.

**NOTE:** If you are working with a team of co-authors, the team should pick one person to create a fork into their Github account. The other authors should collaborate and contribute to that person's fork during the development process.

Okay, ready to get started creating your own What The Hack?

The instructions below assume you have the git command line tool on your machine. If you're more comfortable in a GUI git client, you can use that too (we recommend [Atlassian's SourceTree](https://www.sourcetreeapp.com/)).

1. Create a fork of the WTH repo
   - Navigate to the WTH repo at: <https://aka.ms/wthrepo>
   - Click the "Fork" button at the top right of the page and then choose the account you want to create the fork in. 
1. Clone your new fork to your local machine
   - `git clone https://github.com/<myname>/WhatTheHack.git`
   - `cd WhatTheHack`
1. Create a new branch for your work. It is a best practice to never work directly on the master branch
   - `git branch MyWork`
   - `git checkout MyWork`
1. Add a new top level folder to the WTH repo using "`XXX`" as a placeholder for the number prefix
   - `mkdir XXX-MyAwesomeHack`
1. Within your new folder, create the following directory structure:
	- `../Coach`
		- `/Solutions`
	- `../Student`
		- `/Resources`
1. Follow the [What The Hack Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md) and scaffold out your hack's content as shown here:
    - `../`
        - Hack Description
    - `../Coach`
        - The Coach's Guide, Lecture presentations, and any supporting files.
        - `/Solutions`
            - Solution code for the coach only. These are the answers and should not be shared with students.
    - `../Student`
        - The Student guide's Challenge markdown files
        - `/Resources` 
            - The code and supporting files the students will need throughout the hack.
1. Re-Read the [What The Hack Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md) (seriously) and make sure your hack follows the templates & styles for consistency.

### Release Process

When you feel your hack is finished and ready for release, this is the process we will follow:

1.	The WTH team will assign your new hack a number.	
1.	You should immediately rename your root folder to use that number. (i.e. "`XXX-MyAwesomeHack`" to "`067-MyAwesomeHack`")
1.	The WTH team will schedule a 60-minute "pre-PR review" meeting with you and any co-authors. 
    - The purpose of this meeting is to go through the content together and reduce the amount of back and forth review cycles on Github once your Pull Request is submitted.
    - During this review, the WTH team will go through the text with a fine-toothed comb checking for:
        - Adherence to the [WTH Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md)
        - All links work, especially the navigation links
        - There are no links to the WTH repo or Coach's guide from the Student guide! (See the [WTH Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md))
        - All images show properly.
        - Any syntax, grammar or punctuation problems that the reviewers see and want you to address.
        - This is NOT a technical content review. As the author(s), YOU are the subject matter experts. The WTH team will trust that you have taken care of the technical bits.
    - **NOTE:** It is important that you take notes through-out the meeting so that you can go away, make any changes requested, and not miss anything.
1.	Once you have completed any requested changes from the "pre-PR review", you can submit a pull request to the WTH repo.
1.	The WTH team will review your PR and leave comments if there are any requested changes that still remain. If there are requested changes, please add further comments if you have clarifying questions to ask, or arguments against, the requested changes (that’s ok).
    - **NOTE:** Make any requested changes by continuing to commit to your fork. The PR will automatically update with your changes.  You do NOT need to create a new pull request!
1.	Once you have addressed any requested changes from the WTH team, the WTH team will accept and merge the PR.

### Use work in progress PRs for early feedback

If you choose not to collaborate with the WTH team via Microsoft Teams, alternatively you can use a work-in-progress Pull Request.

A good way to communicate before investing too much time is to create a "Work-in-progress" PR and share it with the WTH team. The standard way of doing this is to add a "[WIP]" prefix in your PR's title and assign the **do-not-merge** label. This will let people looking at your PR know that it is not well baked yet.

The WTH team will review your new hack following the same guidelines as above. However, the process will take longer if we need to spend additional cycles going back and forth within Github's PR process.

## Thank You!
 Your contributions to open source, large or small, make projects like this possible. Thank you for taking the time to contribute.

## And now the fine print...

This project welcomes contributions and suggestions. Most contributions require you to
agree to a Contributor License Agreement (CLA) declaring that you have the right to,
and actually do, grant us the rights to use your contribution.

For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need
to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the
instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

### Use of Third-party code

- Third-party code must include licenses.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the Code of Conduct FAQ
or contact opencode@microsoft.com with any additional questions or comments.

