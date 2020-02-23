# What The Hack
## Here's what you need to know!

- "What the Hack" is a challenge based hackathon format
- Challenges describe high-level tasks and goals to be accomplished
- Challenges are not step-by-step labs
- Attendees work in teams of 3 to 5 people to solve the challenges
- Attendees "learn from" and "share with" each other
- By having to "figure it out", attendee knowledge retention is greater
- Proctors provide guidance, but not answers to the teams
- Emcees provide lectures & demos to setup challenges & review solutions
- What the Hack can be hosted in-person or virtually via MS Teams

## So you want to host a hack?  Here's what you need:

- Hack Hosts
    - Content Owner/Emcee
    - Coaches
        - 1 per 2 attendee teams if in-person
        - 1 per attendee team if virtual
- Hack Attendees
    - Teams of 3-5 people
- 2 MS Teams
    - 1 for the hosts & coaches
    - 1 for the attendees
- Git repo to share all content post-event (not before/during!)

## Content Owner - Responsibilities

- Pick a challenge scenario to be used for your hack
    - Look for existing content that can be repurposed for this format
- Validate that the challenges for your scenario are accomplishable
- Deliver track “content”:
    - Challenge List (document – 1-3 sentences/bullets with expectations)
    - Proctor’s guide (document – see Proctor Guide slide)
    - (Optional) Presentation with lecture slides if emcee or proctors want to demo/explain key concepts before/between challenges
    - (Optional) Pre-staged challenge content (pre-configured VM images, sample code)
- Nominate an emcee for your hack
- Ideally, the content leads should emcee, but if not, you can nominate someone else.
- Help train/brief the Coaches on the challenges before the event

## Challenge List - Guidelines

- Challenges should be cumulative, building upon each other
    - Establish Confidence – start small and simple (think hello world)
    - Build Competence – by having successively more complex challenges
    - Each challenge should provide educational value.  
        -For example, if an attendee completes only 3 out of 7 challenges, he/she still walks away feeling satisfied that he/she has learned something
- Think through what skills/experience you want attendees to walk away with by completing each challenge
- Challenge definitions should be short.  A couple of sentences or bullet points stating the end goal(s) and perhaps a hint at the skill(s) needed 
- Include a “Challenge 0” that has pre-requisites for workstation environment

## Coaches' Guide - Guidelines

- Coaches' guide should have:
    - List of high-level steps to the challenge answers/solutions
    - List of known blockers (things attendees will get hung up on) and recommended hints for solving them
    - List of key concepts that should be explained-to/understood by attendees before a given challenge
    - Estimated time for each challenge (NOT to be shared with attendees)
    - Suggested time a proctor should wait before helping out if a team is not progressing past known blockers
- Coaches' guide may optionally have:
    - Pre-requisites for the Azure environment if needed. 
        - Example: A VM image with Visual Studio or ML tools pre-installed. 
        - Example: An ARM template and/or script that builds out an environment that saves time on solving a challenge
    - Slides that proctors can reference to help when teaching a key concept
    - Scripts/templates/etc for some challenges that can be shared with attendees if they get really stuck
        - Example: If challenges 1-3 build something (i.e. an ARM template) that is needed for challenge 4, you could “give” a stuck team the template so they could skip to challenge 4.
    - List of reference links/articles/documentation that can be shared when attendees get stuck
- Proctor’s guide should be updated during & post event with key learnings on what worked, didn’t work, and unexpected blockers that came up.

## Presentation Lecture (Optional)

- Event kickoff slides covering logistics & event format
- Brief overview of challenge scenario & technology
- Brief overviews of concepts needed to complete challenges
    - Try to keep lectures <10 minutes per challenge
- Slides with Challenge definitions that can be displayed when attendees are working on challenges
- Review of each challenge’s solution to be presented after challenge completion

## Emcee

- Emcee will anchor the room and handle announcements, etc. 
    - i.e.  The person with the skinny microphone!
- Emcee will also help huddle the proctors if they need to share info during the event.
- Emcee will present any content to prep the attendees (event intro, logistics, mini-tech lectures, demos, etc)
- Emcee will maintain list of unexpected blockers (and their solutions) that come up during the event.  These blockers should:
    - Be recorded live to the proctor’s guide and used by the content leads for future events
    - Communicated to the attendees in the room.
- Emcee is responsible for helping attendees form teams.
    - If in-person, this can be driven based on the tables people sit at or balanced by skill set/levels
    - If virtual, randomly nominate team leads, and have the leads pick teammates (like in gym class!) 
- Emcee will constantly solicit feedback throughout the event!

## Coach Responsibilities

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

## Hack Attendee - Responsibilities

- Learn
- Do
- Learn
- Share!

**NOTE:** Attendees should not be judged on how far they get.  No trophies should be given for challenge completion.  If event hosts want to gamify/incentivize attendees, they should focus on encouraging attendees to share with each other!

## Using Microsoft Teams
### Hack Hosts, Coaches & Event Staff

- A private “Hack Hosts” MS Team should be created for the event.
- All hosts (proctors, emcees & event staff) are added to the MS Team before event
- If there are multiple hack tracks, a channel should be created for each hack track
- All proctor’s guides should be loaded into the channel for that track as a tab.
    - Proctors will use teams to access the proctor guide during the event.
    - Any other optional resources for the proctors will be stored in the Files tab (slides, templates, etc)
- Proctors should communicate with each other privately from attendees to share learnings/practices during the event.
- Proctors and emcees can work together to decide if/when to communicate issues broadly to all attendees during the event.

### Hack Attendees

- A “Hack Attendees” MS Team will be created for the event.
    - If an in-person hack, attendees should be instructed to join the MS Team at event kick off
    - If a virtual hack, attendees should be added to the MS Team before the event based on registration
- Each table/team should create their own Channel to share info during the event (code snippets, links, references, screen sharing, etc)
- The event’s “General” channel will have tabs containing the Challenges & “Shared Tips”
    - Challenges tab will be posted by the content owners
    - “Shared Tips” is open to any proctor/attendee/team to share knowledge broadly to all teams.  Since the event is not competitive, sharing SHOULD be encouraged!
- There is also a “Feedback” channel for live event feedback. 

### Hack Attendees Example

**INSERT TEAMS SCREENSHOT HERE**

## Github Repo

- All hack content should be contributed to the What The Hack GitHub repo for sharing post-event
    - https://github.com/Microsoft/WhatTheHack
- The repo should NOT be shared with attendees before or during the event (because it will have the answers!)
- Attendees should be encouraged to re-use the content to train others
- Instructions on how to contribute to the What The Hack GitHub repo and how to structure your files are available in a separate document.