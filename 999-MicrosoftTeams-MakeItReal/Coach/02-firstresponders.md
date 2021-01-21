# Challenge 2: Coach's Guide

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
    * hhu 
    * eded

1. **Demonstrate how your team suggests standardizing the photo gathering business process of first responders. Based on the photo and information gathered, either the Logistics or Engineering team should be notified of the request.**
    * hhu 
    * eded 

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1. **If the mobile device is not managed by the organization, the user is prompted for the multi-factor authentication.**
    * If the group decides to take on this challenge, be sure they only create a policy for one of their users. We don't want to create an unwelcome experience as they work on the other challenges.
    * First, the group will have to enable MFA through the user object in Azure Active Directory. [Steps to enable MFA for user](https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-userstates) 
    * Then they will want to create a new Conditional Access Policy (use a name that clearly maps to the group of participants). In user assignments, specify the user that was enabled earlier.
    ![Creating Conditional Access Policy](images/2condaccess.png)
    Target the Microsoft Teams application
    ![Target MS Teams](images/2condaccessteams.png)
    No Conditions. Grant access if the device is compliant or if MFA is done
    ![Grant Access](images/2condaccessgrant.png)
    Enable the policy. It is best to use a private browser session which will trigger the MFA enrollment. The mobile device (if being used) will likely have a cached token. So signing out and waiting a period of time may be required.


