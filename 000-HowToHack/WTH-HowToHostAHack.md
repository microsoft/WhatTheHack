# How to Host a What The Hack

We've structured the What The Hack format to make it easy to deliver to students both in person and virtually. The following are instructions, tips and tricks to hosting your own What The Hack and have it go off without a hitch.

With the Covid-19 pandemic, virtual events will be the way of the future for some time. Participating in a team-based hands-on event virtually may be a new concept for many. However, we have found that virtual WTH events are often more collaborative than a traditional in-person event!

This document has the following sections:
- [WTH Event Requirements](#what-do-you-need-to-host-a-what-the-hack-event)
- [WTH Event Preparation](#event-preparation)
- [WTH Event Day](#event-day)
- [In-Person Event Tips](#tips-for-in-person)
- [Virtual Event Tips](#tips-for-virtual)

## What do you need to host a What The Hack event?

At minimum, three things:
1. [Hack Content](#hack-content)
1. [Microsoft Teams](#microsoft-teams)
1. [People](#people)

### Hack Content

First and most important is hack content! The What The Hack collection has many different hackathons that have been contributed. 

Choose a hack from the [What The Hack Collection](../readme.md#what-the-hack-collection)

Or, create your own with the guidance we have on [How To Author A What The Hack](WTH-HowToAuthorAHack.md)

### Microsoft Teams

Next, you need Microsoft Teams! Specifically, you will need to create a team for your event that will be used as the dedicated event space that the attendees will collaborate in.

**Note:** While you could host a WTH event using other collaboration tools, we strongly recommend using Microsoft Teams. When we stay "strongly recommend", it means we are writing this document based on using Teams. ;)

During a WTH event, attendees work together in squads* of 3 to 5 people to solve the hack's challenges. The attendees will need to share links, code snippets, or even screen share as they collaborate on the challenge solutions. Microsoft Teams makes this easy to do by having each squad assigned a Channel to work in. 

At an in-person event, each squad will be sitting at the same table. During a virtual event, everyone will be sitting at home in their pajamas. The main difference is that during a virtual event, attendees will need to join a call in their squad's channel for the duration of the event. Most other aspects of the event are the same!

**Note:** Why are the groups of 3 to 5 attendees working together called "squads"? It is natural to call them "teams" or "hack teams". However, the word "teams" is overloaded when we talk about "Microsoft Teams" (the app) and the "team" within the app that is created for the event! So, "squads" it is!

### People 

Finally, you need people to hack! There are a few different roles that will need to be played at your What The Hack event. They include:
- Lead Coach
	- The lead of the event both logistically and technically. 
	- Responsible for the event preparation steps [outlined below](#event-preparation).
	- This person should be intimately familiar with the content and all of its solutions.
	- Delivers kick off meeting & challenge intro lecture presentations (if required)
- Coaches
	- 'Coach' of a squad of 3 to 5 attendees.
	- Recommended to have 1 coach per every 5 attendees. At minimum, need 1 coach per every 10 attendees
	- Provides guidance and direction for the squad but does **NOT** provide answers.
	- In charge of determining whether a squad has finished a challenge and should move to the next one.
- Attendees
	- The students in the event that participate in squads of 3 to 5.
	- Must join and participate in their squad's Teams channel

## Event Preparation

If you've gotten this far, then you have designated yourself as "Lead Coach" and are starting to prepare to host a WTH event!

As the event leader, most of the preparation steps are focused on preparing Microsoft Teams for the event. The preparation checklist focuses on three key areas:

- [Know Your Audience](#know-your-audience)
- [Microsoft Team Creation](#microsoft-team-creation)
- [Getting People To Your Event](#getting-people-to-your-event)

### Know Your Audience

If you are inviting attendees that are outside of your organization, there are multiple things to think about with respect to using Azure and Microsoft Teams. It is a good practice to identify an event stakeholder in the external organization who can help you plan for your What The Hack event.

#### Guest Access

You will need to have “Guest” access enabled in your Microsoft Teams tenant to have the external individuals to be part of the event. External attendees are not required to have a user license in Microsoft Teams. You will be inviting them into your event's team as a guest. This is covered by your organization’s guest licenses which are included with its Office 365 license. 

#### Reverse Guest Access

If your attendees are all from the same external organization and that organization has its own Microsoft Teams tenant, it is easier to host the hack event's team in the external organization's tenant. Then, have the organization stakeholder invite you and/or the other coaches to join their team as a guest.

This provides the benefit of the external organization having full access and control of all resources, discussions, and knowledge shared in the event team once the event has completed.

#### Audio Conferencing

Some individuals may not have a computer with speakers and a microphone or be equipped with a headset. In that case, you will need to provide a dial-in number for the event. This will require that you have the “Audio Conferencing” license within your Microsoft Teams account (included in the Office 365 E5 plan). 

Individuals that join in over their computer or mobile device will leverage voice over IP and do not require the Audio Conferencing license. In all cases people will utilize the Microsoft Teams client or a web browser to join the video, screen sharing, and collaboration aspects within Microsoft Teams.

#### Privacy

When inviting external participants, make sure you follow your organization's privacy policies. At a minimum, make sure to disclose to the attendees that all members of the event will be able to see each others Name, Email Address, and anything they say and share within the various channels within the team.

#### Azure Subscription

Most of the hacks in the What The Hack collection require attendees to have "Contributor" access to an Azure subscription. 

It is important to work with the organization stakeholder to decide how attendees will access Azure. Some organizations may provide individuals with their own subscriptions.  Other organizations may provide access to a shared subscription created specifically for attendees to use during the hack event. 

If the organization provides the attendees with access to an Azure subscription, it is a good practice to share what the predicted cost of Azure resources used during the hack will be.

If the organization is not providing an Azure subscription, attendees can use the free Azure subscription that comes with their personal MSDN subscription.

Finally, attendees can create a free trial Azure account to participate in the hack event.

#### Workstation Security

Some organizations have tight security policies enforced on their employees' workstations. A common one is to not provide users with adminstrator priviledges on their workstation. If this is the case, it may prevent them from installing tools or software needed to complete the hack.  

One workaround is to use the Azure Cloud Shell. However, some organizations may disable access to the Azure Cloud Shell!  Another workaround is to provision a workstation VM in Azure that attendees can RDP into to complete the hack.

Tight firewalls may make it challenging to access Azure from an organization's workstations. This is when you bang your head against the wall, give up, and be thankful you don't work for that organization! :)

All of these security concerns and their mitigations should be identified and addressed with the organization stakeholder ahead of time.

### Microsoft Team Creation

Create a new team for your WTH event in Microsoft Teams that will be used as the dedicated event space. This space will host documents, multiple channels for presenting, screen sharing, and overall collaboration in real and near real-time. 

We recommend creating the following Channels in the team:

- **General** – The general channel will be used as the central gathering place. All event challenges, documents, and supporting material will be hosted in this channel. Key event items can be pinned up within various Tabs. Within the general channel we will host the kickoff meeting to start the event and have various checkpoints throughout the event to communicate with the all the attendees at once. 
- **Coaches ONLY (Private)** - Coaches should communicate with each other privately from attendees to share learnings/practices during the event. Coaches can work together to decide if/when to communicate issues broadly to all attendees during the event.
- **Feedback** - Encourage attendees to post feed back during & after the event so coaches can improve it for future events
- **Squad Channels** – The Squad channels will be where teams of individuals will go to work and collaborate during the event. We find groups of 3 to 5 people work well. Based on the number of individuals in your event, you will need to create the number of group channels required to support your event.
- **Coach Channels** – The Coach channels are dedicated spaces where a coach can meet 1:1 with specific person to help work through some task or issue during the event. We find that we need 1 proctor for about 15 to 20 attendees. You should create a dedicated coach channel for each coach that will be part of the event. 

**Insert Screenshot of Sample WTH Event Team**

- Add participants to your newly created Microsoft Team a few days before your event to give people time to log into the Team. In addition if you have some preparation materials make sure to communicate that to the users as part of the Team Invite or within the General Channel.
- Schedule a Channel meeting in the General Channel of your event Team and send the meeting invite to your attendees
- Upload any documents, challenges, pre-work, and supporting materials into to General Channel files area.
- Post any announcements or start any relevant conversations in the General channel to provide details and clarity of your event. 
- Determine how you may want to break the attendees up into smaller peer groups during the group challenges based on the style of the event you will be delivering.

ToDO...

- Pre-load hack content
	- Pin challenges tab
	- Channel Creation
	- Event kick off PPT template
	- Downgit Student resources into Files tab
	- Coach guide posted in Coaches ONLY channel for coaches to have easy access?
	- Any other optional resources for the coaches will be stored in the Files tab of the Coaches ONLY channel (slides, templates, etc)

	- The event’s “General” channel will have tabs containing the Challenges & “Shared Tips”
    - Challenges tab will be posted by the content owners
    - “Shared Tips” is open to any proctor/attendee/team to share knowledge broadly to all teams.  Since the event is not competitive, sharing SHOULD be encouraged!
- There is also a “Feedback” channel for live event feedback. 

### Getting People To Your Event

- Registration and invites
	- Advertise your hack!
	- Registration
	- Use Microsoft Forms and Flow
- Calendar Blocks! (especially for a virtual event!)
	- Link to the General Channel
	- Include a "join code" if internal audience

## Event Day 
(Running your WTH Event)
	
### Kick-Off Meeting 
- Use the Event KickOff presentation to cover logistics
- Join the General Channel meeting at the start of your event. Communicate to the attendees the details and flow of the event. We highly recommend using video on during this session as it really helps drive the collaboration and interaction with the group. 
- In-Person
	- Attendees join team via join code
- Virtual
	- Attendees join via the "Meet Now" meeting in the General Channel
- Lead Coach covers logistics
- Forming Squads
	- Load balanced by skill level
	- Segregated by skill level
	- Up to event organizers
	- Virtual: Squads by TimeZone

 - If an in-person hack, attendees should be instructed to join the MS Team at event kick off
    - If a virtual hack, attendees should be added to the MS Team before the event based on registration
- Each table/team should create their own Channel to share info during the event (code snippets, links, references, screen sharing, etc)

### Hacking

- When its time to break out into the various peer groups, the individuals will leave the meeting in the General channel. They will then go to their chosen Group Channel and participate in a meeting in that channel. Please be aware the first person enter the channel will hit the “Meet now” button within the channel (as indicated by the red arrow below) to start the channel meeting. All subsequent individuals will see a notice that there is an active meeting and can simply hit the “Join” button. Please note, you can have multiple meetings happening within a channel. In some situations it may be ideal to spin up additional meetings, for example if the group is large.
- In-Person
	- Tables work together
	- Screenshare via squad channels
- Virtual
	- "Meet Now" in squad channels
	- Use channel for chat & screensharing

- The individuals within the groups can now work together on their tasks, share screens, links, and other tasks to achieve their goals. As people get stuck we highly recommend that they talk through the issues with the group and share their screen with the team to work through the challenge. Group collaboration is a very effective learning tool.
- The Proctors can stay in the General Channel as a central place people can find then if they need to escalate. In addition, the proctors can quickly jump in and out of the various Group channels to check in on the group and provide support as required by joining the various channel meetings.
- In the event, a person within the group is having a problem that requires individual attention the proctor can ask the individual to go to the proctor’s dedicated channel where they can start a channel meeting and work together to resolve the issues. 
- Throughout the event, you may want to have various checkpoints that require all the individuals to come back to the General Channel to meet and discuss the tasks done and next steps.
- In addition, as folks find useful tips and tricks, you can direct them to share those items in the General Channel as a Chat or within a shared OneNote, Word Document, etc. if the event is a hackathon style event. For Lab-style events folks can leave tips and tricks in the various exercise channels to keep the content relevant to the issue.
- Present challenge lectures when 80% of the squads appear to have completed the previous challenge.  Ask those still working to pay attention to the short lecture, then return to completing the previous challenge.

#### Coach Responsibilities

- Keep the teams working as teams!
    - Encourage all to “learn from” and “share with” each other!
    - If you observe individuals racing ahead, encourage them to help those who are behind.
    - Encourage attendees to use their team’s channel on MS Teams to collaborate/share info! 
- Unblock teams who get stuck 
    - Encourage team members to unblock each other first!
    - Provide hints, but not answers
    - If you observe individuals stuck for a while, help them get moving so they don’t lose interest.
- Provide hints/pointers to the teams on how to solve problems & where to find information.
    - Use the answers/solutions in the proctor’s guide, but don’t share with the attendees
    - Proctor’s guide won’t be comprehensive.  As SMEs, proctors should use their knowledge to help with solution hints/ideas.  
- Notify the emcee of unexpected blockers that arise during the event so they can be communicated to all, and recorded for future reference.

- **GF NOTE** `I want to remove this bullet, there is to be no guidance on post challenge stuff, if anything we should discourage it. Remember 'do not be beholden to the clock'? We have to account for slow tables vs. fast tables`
  - Review of each challenge’s solution to be presented after challenge completion


#### Hack Attendee - Responsibilities

- Learn
- Do
- Learn
- Share!

**NOTE:** Attendees should not be judged on how far they get.  No trophies should be given for challenge completion.  If event hosts want to gamify/incentivize attendees, they should focus on encouraging attendees to share with each other!

### Stand-Ups/Check-ins
### Regular breaks

## Tips for In Person
	• Food, food, glorious food!
	• Emcee
## Tips for Virtual
	• List of tips from OH deck!

**Tip:** With the Covid-19 pandemic, virtual events will be the way of the future for some time. If you are working from home, take advantage of this time to sharpen your skills by hosting or participating in a virtual WTH event!



# Event Kick Off Presentation
You can find a Powerpoint presentation template you can use to kick off your What The Hack.

In it we have put most of the instructions above in a form that you can present to the attendees before starting the What The Hack.