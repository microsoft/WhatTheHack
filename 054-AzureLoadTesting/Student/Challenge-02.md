# Challenge 02 - Create a Load Testing Script

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

- Ensure you have outlined your load testing strategy as described in the previous challenge.

## Introduction

In this challenge, you will create your load testing script. Your load testing script should target the 3 application endpoints and implement the load testing strategy you created in the previous challenge. Your scripts should help you get a baseline for how the application can handle typical user loads.

Azure Load Testing is based on Apache JMeter - a popular open source load testing tool. This means you can reuse existing JMeter scripts or create new scripts by using the JMeter GUI.

## Description

- Using the JMeter GUI, create a load testing script that targets the 3 application endpoints:
    - (Get) Get - carries a get operation from the database to retrieve the current count
    - (Post) Add - Updates the database with the number of visitors.  You will need to pass the number of visits to increment.
    - (Get) lasttimestamp - Updates the time stamp since this was accessed.
- Execute the load test using the JMeter GUI against your 3 endpoints and use the Azure portal to confirm the App Service is getting the traffic.

## Success Criteria

- Verify have a load testing script (.jmx) created that targets the 3 application endpoints.
- Verify your load test in JMeter works and you are able to see the load in your sample application.

## Learning Resources

- [Node.js sample application](https://github.com/Whowong/nodejs-appsvc-loadtest)
- [Apache JMeter Docs](https://jmeter.apache.org/index.html)
- [Create Test Plan from Template](https://jmeter.apache.org/usermanual/get-started.html#template)
- [JMeter best practices](https://jmeter.apache.org/usermanual/best-practices.html)
- [Custom Plugins for Apache JMeter](https://jmeter-plugins.org/)

## Advanced Challenges (Optional)
- Your initial load test scripts may gradually increase load in a linear rate.  What if you wanted to simulate users starting their day at work at different time zones?  See if you are able to create a load test which steps into higher load like a stairway.
