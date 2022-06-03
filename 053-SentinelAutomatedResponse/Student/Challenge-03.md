

# Challenge 03 - Automated Response </br>

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** 

## Pre-requisites 

Verify your environment </br>
- Creates an alert based on your user login </br>
- Creates an Incident per Alert</br>
- Watchlist is created
  </br>


## Introduction 

Now we have our alert rule running, the SOC team is finding that its just way too 'noisy' because every time an admin logs on, it's generating an Alerts and an Incidents. It's your job to ensure that the Alert must trigger whenever an administrator logs in and create an Incident, AND, the Incident should be automatically closed if the IP address exists in the Watchlist. 


## Description
We want to automatically update your Security Teams channel when the Incident is not automatically closed.

**Close the Incident automatically**
</br>
- Close an alert/incident using the Watchlist and a Playbook when the IP is a known (ie is in the Watchlist) IP. </br>
- Ensure that an Incident is created when the login IP is not contained in the list of Watchlist IP addresses. </br>

Hint: When you log on, if your IP is in the Watchlist, automatically close the alert/incident </br>

**Update The Workbook**</br></br>
Send a message to your security operations channel in Microsoft Teams or Slack to make sure your security analysts are aware of the incident.


## Success Criteria

**Close the Incident automatically** </br></br>You have implemented a playbook that automatically closes the Incident if the IP address of the administrator/logon user is included in your Watchlist. And, you've verified that an Incident is created if you login from and IP address that is NOT in the Watchlist.

**Update the Workbook**</br></br>When an incident is **not** automatically closed, your security Teams channel is notified.


## Learning Resources

**[Sentinel github repository](  https://github.com/Azure/Azure-Sentinel)**

**[Sentinel playbooks – understanding API connection]( https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/understanding-api-connections-for-your-microsoft-sentinel/ba-p/2593973)**

**[Teams and email](  https://docs.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks)**

**[Playbooks with automation rules](https://docs.microsoft.com/en-us/azure/sentinel/tutorial-respond-threats-playbook?tabs=LAC)**


## Tips


Check the github repositoring for existing Logic Apps/ Playbooks. </br>

When adding the Playbook, you need to Manage playbook permissions (in blue, just under the Actions heading). </br>

Read the learning resource abouve on automated response to find out how to link into Teams (and you can search the web for additional info). </br>

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Add functionality to the Incident creation that sends an email to the SOC team (you) when an Incident is created, but not when and Incident is automatically closed.  Keep costs to a minimum.
- Figure out how to publish the workbook so that management can view it, but can't make any changes.
- Add additional useful Entity objects to help the SOC team with investigations.

