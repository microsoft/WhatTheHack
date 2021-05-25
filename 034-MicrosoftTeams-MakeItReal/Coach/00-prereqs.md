# Challenge 0: Coach's Guide

**[Home](./readme.md)** - [Next Challenge >](./01-collaboration.md)

## Notes & Guidance
This hack includes a [Sample Invite](./Resources/SampleInvite.oft) which you can modify to give you an idea of how we recommend advertising this offering.

The ideal size of a participant team for this hack is 4-5 people. The number of teams you can support is proportionally related to how many coaches you have to provide assistance when a team gets stuck or has questions. It is recommended to limit a coach to 1 or 2 teams so they are available and there isn't a lot of wasted time by the participants.

Ideally, each participant in a team has a unique login to an Office 365 environment, but they don't necessarily need their own tenant. In fact, there is only one advanced challenge where there is the possibility of admins colliding. It is possible to host several teams in a single Office 365 tenant. Each hack team though will create a single Microsoft Team collaboration area where their accounts are members.

Ideally, we recommend that the host provide this environment instead of the teams signing up for their own trials. If you are a Microsoft employee or partner, a CIE tenant provisioned through [CDX](https://demos.microsoft.com) is a perfect start. An Office 365 E5 trial would work too. The reason recommending a host provided tenant is that there are several configurations in the tenant that should be setup in advance of the hack. Some of these configurations (Teams guest access) can take up to 24hrs to set, so please do these in advance. 

Required Configurations:
- We recommend setting an easier to enter password for the users in the tenant. The first block of commands in this [PowerShell script](./Resources/MakeItReal.ps1) assign a password to all the user accounts.
- For every user to do any action in the hack, we recommend making all the accounts Global Admins. The [PowerShell script](./Resources/MakeItReal.ps1) has an example of how to do that.
- In the Microsoft Teams admin center, you will need to create a new Emergency Location. We recommend using a Microsoft address or the customer's location. [Adding an emergency location](https://docs.microsoft.com/en-us/MicrosoftTeams/add-change-remove-emergency-location-organization)
- For participants to experience dialing telephone numbers, you will need to Purchase Services and add a Domestic Calling Plan trial subscription to the tenant.
- The [PowerShell script](./Resources/MakeItReal.ps1) has a sample for how to assign the calling plan licenses to your users. The prefix for the tenant will be unique to your environment.
- In the Microsoft Teams admin center, request phone numbers for a local area code where you will be hosting the hack. [Getting phone numbers for your users](https://docs.microsoft.com/en-us/microsoftteams/getting-phone-numbers-for-your-users)
- Assign a phone number and the emergency location to each of the tenant's users. [Assign a phone number to a user](https://docs.microsoft.com/en-us/microsoftteams/assign-change-or-remove-a-phone-number-for-a-user)
- Confirm that Guest Access is turned on for Microsoft Teams. [Setup Guest Access](https://docs.microsoft.com/en-us/microsoftteams/set-up-guests)
- Configure Microsoft Teams Live Events settings so that Everyone can join and schedule them. Also enable the service to always record them. [Setup Live Events](https://docs.microsoft.com/en-us/microsoftteams/teams-live-events/set-up-for-teams-live-events)
