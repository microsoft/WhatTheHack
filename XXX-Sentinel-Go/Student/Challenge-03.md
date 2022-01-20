

# Challenge #3:  Automated Response </br>

[< Previous Challenge](./Challenge-X-1.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge-X+1.md)

## Pre-requisites (Optional)


**Verify your environment </br>
         – Creates an alert based on your user login </br>
         – Creates an Incident per Alert</br>
         – Watchlist is created**
  </br>


## Introduction (Optional)

**Now we have our alert rule running, the SOC team is finding that its just way too 'noisy' because every time an admin logs on, it's generating an Alert and an Incidents. It's your job to ensure that the Alert must trigger whenever an administrator logs in and create an Incident, AND, the Incident should be automatically closed if the IP address exists in the Watchlist**


## Description

**Part 1: Close the Incident automatically**
</br>
i. Close an alert/incident using the Watchlist and a Playbook when the IP is a known (ie is in the Watchlist) IP. </br>
ii. Ensure that an Incident is created when the login IP is not contained in the list of Watchlist IP addresses. </br>

Hint: When you logon, if your IP is in the Watchlist, automatically close the alert/incident </br>

**Part 2: Update The Workbook**

i. Update the workbook you created in Challenge #2 to include a view that shows both the total number of automatically closed incidents, and those that were not automaticallly closed. </br>
ii. Create a view that shows the cost of automatically closing these incidents.


## Success Criteria

For Part 1, you have implemented a playbook that automatically closes the Incident if the IP address of the administrator/logon user is included in your Watchlist. And, you've verified that an Incident is created if you login from and IP address that is NOT in the Watchlist.

For Part 2, you have updated the workbook so that it tracks the total number of automatically closed Incidents, and the total number of active Incidents.  You have also figured out how to show the cost associated with automatically the Incidents.


## Learning Resources

Sentinel github repository:  https://github.com/Azure/Azure-Sentinel

Sentinel playbooks – understanding API connection: https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/understanding-api-connections-for-your-microsoft-sentinel/ba-p/2593973




## Tips

Read up on logic apps with Sentinel </br>

Check the github repositoring for existing Logic Apps/ Playbooks. </br>

When adding the Playbook, you need to Manage playbook permissions (in blue, just under the Actions heading). </br>



## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

1) Add functionality to the Incident creation that sends an email to the SOC team (you) when an Incident is created, but not when and Incident is automatically closed.  Keep costs to a minimum.
2) Figure out how to publish the workbook so that management can view it, but can't make any changes.
3) Add additional useful Entity objects to help the SOC team with investigations.

