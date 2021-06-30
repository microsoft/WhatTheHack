# Challenge 10: Monitor and Manage the Performance and Health of your AVD Environment

[< Previous Challenge](./09-Automate-AVD-Tasks.md) - **[Home](../README.md)** - [Next Challenge>](./11-Configure-User-Experience-Settings.md)

## Introduction

You've recently deployed AVD for your company and each region started off ok however users have begun reporting problems occasional issues with connecting and performance has become progressively worse for some of the sessions. You need to offer a way to gather information to troubleshoot these issues and because they happen infrequently and across a range of users and times you need to be able to efficiently capture and record these events. It's important that you also can be more proactive to issues in the environment before they cause too much impact on the user experience. Your manager is also concerned about the cost of running so many AVD hosts across each of the regions when staff are not working and VMs may be sitting idle and wants to look at ways to reduce costs without negatively impacting the users when they login each morning. Lastly many users wish to use Microsoft Teams when connected to AVD hosts and use audio and video for their online meetings and although it works, users report regular stuttering during meetings and have asked whether it's possible to improve the experience.

## Description

The goal of this challenge is to demonstrate how you can enable a monitoring solution for AVD and how it may be used to identify and diagnose issues across your deployment. Using this information you should be able to pull in AVD service information, performance metrics and event log information that relates to the service and present it within the AVD insights dashboard. Your environment should also be enabled for automatic scaling based on your companies requirements to optimise costs and ensure sufficient capacity per your peak hour requirements.

**NOTE:** Scaling Automation was deployed in Challenge 9

### AVD Monitoring

- Azure offers numerous ways to monitor resources your solution should offer a view that targets the AVD service diagnostics and host performance and events
- The service needs to have the ability to report on both live information and historical information for at least 30 days
- Information needs to be presented in an easy to consume dashboard and offer a way to filter views based on which region you're attempting to monitor

### Cost Optimization and Session Host scaling

- Assume each region starts seeing staff logon between 8am and 9:30am, there is no sudden spike in logons. The office is closed by 7pm.  
- Users can be forcibly logged off after receiving a 5 minute warning if they are still connected to an active host
- Approximately 5% of users in each region may attempt to connect from home each night and AVD should be available to them off-peak across each region and meets the cost saving targets set by the company
- AVD Session Hosts should be gradually powered on as morning peak demand increases and existing hosts should be filled up before additional VMs are powered on to reduce excess capacity.

## Success Criteria

To be successful for this challenge you should be able to demonstrate the following;

- Identify the top errors preventing users from connecting over the past 24 hours
- Select a host pool and show a view with the following information for each AVD host: New Session Status, Stack Version, Current Sessions, Available Sessions
- Display recent user activity in AVD activity for a specific user including their most recent login and history within the past 30 days
- Identify performance metrics of a AVD host which has a currently connected user and demonstrate how you can view the "User Input Delay per Process" object and "Max Input Delay" counters for that VM.
- Enable automatic scaling of AVD session hosts to start and stop machines during peak/off-peak hours across each region. Consider how the peak/off-peak hours and load balancing will influence the configuration. Assume for the purpose of this workshop that VM sizing and user density is designed for a 1CPU per Session to help with testing in a limited size environment.

## Tips

The logging information may take a few minutes to appear in the monitoring portal. You'll also need to generate user traffic by connecting to AVD after enabling the diagnostics for information to flow through.

To simulate connection errors you may wish to attempt logins with invalid credentials, closing the client during the logon attempt and deliberately using a different account between the logon to the AVD portal and the AVD session host which should fail.

Simulate an unavailable session host by manually stopping the AVD service "RdAgent".

## Advanced Challenges (Optional)

1. Modify the AVD Insights portal to display the CPU % performance metric for the current host pool on the front page of the dashboard. You will need to ensure the metric is only displayed on the Overview tab.
