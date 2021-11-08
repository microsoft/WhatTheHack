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

### On-Boarding Process

Once you have submitted an [Issue/Proposal](https://aka.ms/wthproposal) via Github, you can expect the following:

TODO: Add a note about how we encourage authors to collaborate via Microsoft Teams. This part of the process is optional, but recommended.

1.	WTH Leads will get in touch to start the on-boarding process. If they are aware of other authors with similar proposals, they will schedule a meeting with everyone to see if it makes sense to combine efforts.
1.	WTH Leads will update the What The Hack teams site and:
    - Add everyone in your team to the What The Hack teams site.
    - Create a new channel for you named the same as your new WTH.
    - Add a copy of the WTH Outline Template:
        - WTH Leads will create a copy of the “WTH-ProposalAndAbstract.docx” and copy this file to the Files tab of your new channel and draw everyone’s attention to it.
1.	The WTH Leads will schedule a 1-hour kick off call your entire team when everyone is available to:
    - Explain if/why there are extra teammates you are being combined with.
    - Walk through the What The Hack team, your channel and the Outline document they can optionally use.
    - They’ll be setting up a 30 minute cadence call every two weeks to address any questions or requests you have during development.
    - Walk through the How to Author document. 
        - Everyone on your team still needs to read and internalize this document to save you trouble and heartache down the line.
    - Discuss your plan for the hack and how it fits the format of What The Hack.
1.	During the cadence call, your team will dictate the pace of the call and report what they have worked on. It is essentially your call to discuss things. Even if there is a stint that nothing was worked on, that’s totally fine.

### Development Process / Pull Requests

TODO: To start work, you fork and do your work there.  Share in Teams. Re-iterate the Author's guide!

All contributions come through pull requests. To submit a proposed change, we recommend following this workflow:

1. Make sure there's an issue (bug or proposal) raised, which sets the expectations for the contribution you are about to make.
1. Read the [What The Hack Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md).
1. Fork the **WhatTheHack** repo into your own Github account and create a new branch
1. Create your change
    - Modify an existing hack.
    - Or, scaffold out your new hack with the markdown templates provided in the [WTH Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md), then author your new hack. 
1. Re-Read the [What The Hack Author's Guide](./000-HowToHack/WTH-HowToAuthorAHack.md) (seriously) and make sure your hack follows the templates & styles for consistency.
1. Let the What The Hack team schedule a review.
1. Commit and open a PR
1. Wait for the CI process to finish and make sure all checks are green
1. A maintainer of the project will be assigned, and you can expect a review within a few days

### Use work-in-progress PRs for early feedback

TODO: If you choose to not work via teams, alternatively you can use a WIP PR....

A good way to communicate before investing too much time is to create a "Work-in-progress" PR and share it with your reviewers. The standard way of doing this is to add a "[WIP]" prefix in your PR's title and assign the **do-not-merge** label. This will let people looking at your PR know that it is not well baked yet.

### Release Process

When you feel your hack and finished and ready for release, this is the process we will follow.

1.	The WTH Leads will assign you a new hack number.	
1.	You should immediately rename your root folder to use that number.
1.	The WTH Leads will schedule a 60-minute call with your team for the final review.
    - This review is the first pass through the hack, the WTH reviewers will be going through the text with a fine-toothed comb checking for:
        - Adherence with the How To Author style-guide.
        - All links work, especially the navigation links
        - All images show properly.
        - This is NOT a content review, as the authors YOU are the SMEs so the reviewers are trusting that you’ve taken care of the technical bits.
        - Any syntax, grammar or punction problems that the reviewers see and want you to address.
    - NOTE: It is important that you take notes through-out the meeting so you can go away and make these changes and not miss anything.
1.	Once you have completed the changes, you’ll need to submit a pull request.
1.	WTH reviewers will now look at your PR and leave comments about problems that still remain. When you see these comments submitted leave further comments if you have clarifying questions to ask or arguments against the change (that’s ok).
1.	Once you have addressed all the issues from all the reviewers, the WTH maintainers will accept and merge the PR.


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

