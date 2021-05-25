# Challenge 2: First Responders Coach's Guide

[< Previous Challenge](./01-collaboration.md) - **[Home](./readme.md)** - [Next Challenge>](./03-citizenservices.md)

## Notes & Guidance
Being the coaches guide, this content includes comments, guidance, possible gotchas related to the challenges facing the partipants. The success criteria for the challenge has been duplicated here, but within them, you will find the notes for coaches. In many cases, there is no single solution so coaches are encouraged to be flexibile and focus on the outcome. Did the team accomplish the spirit of the task not necessarily did they do it in the way it is described here?
## Success Criteria
1. **Demonstrate that a user can access the emergency information from a mobile device.**
    * Have someone login to Microsoft teams from a mobile device 
    * Generally we don't provide mobile devices to groups during the hack, so if the group is uncomfrtable doing that with their personal device, don't hold it against them.

1. **Demonstrate that a user can take a set of documents from the emergency documentation offline on a device.**
    * This is to get the users the experience of syncing documents for offline access. On a PC this can be accessed within Teams from the Sync option. It will start the initialization of the OD4B sync client on the machine if that has not been set up. 
    * Through mobile, this can be done with the OneDrive mobile app as well.

1. **Demonstrate the ability to schedule and host a meeting where a user could dial in through telephony without the Microsoft Teams client.**
    * Could technically be done through Outlook or Teams.
    * In the Teams calendar, be sure the group chooses to publish the meeting to the first responder's channel of their emergency team.
    * After creating the meeting request, Teams will automatically add the audio conferencing details provided that option has been configured in the tenant.

1. **Demonstrate how your team suggests standardizing the photo gathering business process of first responders. Based on the photo and information gathered, either the Logistics or Engineering team should be notified of the request.**
    * This challenge could be done with the Power Platform, Microsoft Dataverse for Teams, or just a SharePoint list as the repository.  
    * Gov cloud customers typically gravitate to SharePoint lists as the other choices are not fully available.
    * If a SP list is being used, make sure it is created in the SharePoint site backing the file storage in MS Teams so the security context remains consistent.
    * The list should have a choice column of Logistics or Engineering to help with the routing.
    * The Attachments feature of a SP list is good enough for gathering the photo.
    * They should pin the list to the First Responders channel in Teams.
    * A Power Automate flow should be created triggering of the creation of a new item in the list.
    * The "Post a message to Microsoft Teams for a selcted item" flow template for SharePoint is a good starting point, but you will have to change the trigger to "When a new item is created".\
    ![Trigger On New Item](images/2newitemtrigger.png)
    * A condition action helps create paths for each of the request type choices.\
    ![Condition](images/2condition.png)
    * The correct team can be alerted by posting a teams message in the correct channel. Dynamic placeholders can be used to provide details of the specific request.\
    ![Post Message](images/2postmessage.png)  
    * One the group create's one "Post Message" action they can copy and paste it into the other branch.
    * The entire flow could look something like this:\
    ![Flow](images/2flow.png)
    * Creating with with Microsoft Dataverse for Teams would be very similar accept that the data repository would be the strucutured "CDS-lite" database and the group would need to use the PowerApp designer to modify the input screens.
    * If the group wanted to make the message in Teams more appealing, they can use adaptive cards:
        * https://docs.microsoft.com/en-us/connectors/teams/#post-your-own-adaptive-card-as-the-flow-bot-to-a-channel
        * https://docs.microsoft.com/en-us/microsoftteams/platform/task-modules-and-cards/cards/cards-reference
    * Some groups may take the mobile requirement and decide to build a PowerApp on top of the SharePoint list. https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/app-from-sharepoint
    * Using the Camera control in a canvas application and getting that image into SharePoint can be a bit of a chore. If the group needs more info on this subject, use this link https://blogs.perficient.com/2018/10/08/store-powerapp-camera-photos-in-sharepoint-or-onedrive/

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1. **If the mobile device is not managed by the organization, the user is prompted for the multi-factor authentication.**
    * If the group decides to take on this challenge, be sure they only create a policy for one of their users. We don't want to create an unwelcome experience as they work on the other challenges.
    * First, the group will have to enable MFA through the user object in Azure Active Directory. [Steps to enable MFA for user](https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-userstates) 
    * Then they will want to create a new Conditional Access Policy (use a name that clearly maps to the group of participants). In user assignments, specify the user that was enabled earlier.\
    ![Creating Conditional Access Policy](images/2condaccess.png)\
    Target the Microsoft Teams application\
    ![Target MS Teams](images/2condaccessteams.png)\
    No Conditions. Grant access if the device is compliant or if MFA is done\
    ![Grant Access](images/2condaccessgrant.png)\
    Enable the policy. It is best to use a private browser session which will trigger the MFA enrollment. The mobile device (if being used) will likely have a cached token. So signing out and waiting a period of time may be required.


