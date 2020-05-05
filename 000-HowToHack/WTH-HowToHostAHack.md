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
- General Channel
- Coaches Channel (Private)
- Feedback Channel
- Squad Channels
- Pre-load hack content
	- Pin challenges tab
	- Channel Creation
	- Event kick off PPT template
	- Downgit Student resources into Files tab

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
### Hacking
- In-Person
	- Tables work together
	- Screenshare via squad channels
- Virtual
	- "Meet Now" in squad channels
	- Use channel for chat & screensharing

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



# Using MS Teams
**GF: PETER TO FILL THIS SECTION IN WITH TEAMS CONTENT FROM THE POWER POINT**

Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

# Kicking Off Your What The Hack
**GF: PETER TO FILL THIS SECTION IN WITH TEAMS CONTENT FROM THE POWER POINT**

Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

# Coach Stand-Ups
**GF: PETER TO FILL THIS SECTION IN WITH TEAMS CONTENT FROM THE POWER POINT**

Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

# Tips - In Person Delivery
**GF: PETER TO FILL THIS SECTION IN WITH TEAMS CONTENT FROM THE POWER POINT**

Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

# Tips - Virtual Delivery
**GF: PETER TO FILL THIS SECTION IN WITH TEAMS CONTENT FROM THE POWER POINT**

Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

# Event Kick Off Presentation
You can find a Powerpoint presentation template you can use to kick off your What The Hack.

In it we have put most of the instructions above in a form that you can present to the attendees before starting the What The Hack.