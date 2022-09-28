# Challenge 02 - Monitoring Basics and Dashboards

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

After deploying your initial solution for eshoponweb, you want to make sure that the telemetry is collected from the VMs deployed and display the results on a dashboard for visualization and alerting purposes. To accomplish this, you will have to understand the concept of counters, how to collect them, and how to display them on a Dashboard.

## Description

Using HammerDB to stress the SQL database, you will collect the database and CPU counters of the VMSS using Datadog and display the results on the dashboard.

In this challenge you need to complete the following management tasks:
- Create an empty database called “tpcc” on the SQL Server VM
    **NOTE:** Use SQL Auth with the username being sqladmin and password being whatever you used during deployment
- On the SQL Server VM, complete the Datadog install and configure database monitoring
    - Configure Datadog agent's API key
    - Update the sample SQL Server check in order to connect to the DB
    - Run the Datadog agent's `status` subcommand and look for `sqlserver` in the Checks section  
    - Find sqlserver.queries.count in Metrics Explorer
- Use HammerDB to create transaction load
    - Download and Install HammerDB tool on the Visual Studio VM (instructions are in your Student\Guides\Day-1 folder for setting up and using HammerDB.
- From Datadog, create a graph for the SQL Server Queries and Percent CPU, then add both to a Dashboard
- From Datadog, create an Alert to send an email for the following:
- Create an Alert if Queries goes over 40 on the SQL Server tpcc database.
- Create an Alert for CPU over 75% on the Virtual Scale Set that emails me when you go over the threshold.
    **NOTE:** In the `\Challenge-02` folder you will find a CPU load script to use.


## Success Criteria

*Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach.* 

*The success criteria should not be a list of instructions.*

*Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."*

*Sample success criteria for the IoT sample challenge:*

To complete this challenge successfully, you should be able to:
- Verify that the IoT device boots properly after its thingamajig is configured.
- Verify that the thingamajig can connect to the mothership.
- Demonstrate that the thingamajic will not connect to the IoTProxyShip

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

*Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario.*

***Note:** Use descriptive text for each link instead of just URLs.*

*Sample IoT resource links:*

- [SQL Server Integration Tile]([https://www.bing.com/search?q=what+is+a+thingamajig](https://us3.datadoghq.com/integrations/sql-server))
- [Datadog SQL Server DBM Docs]([https://www.youtube.com/watch?v=dQw4w9WgXcQ](https://docs.datadoghq.com/database_monitoring/setup_sql_server/selfhosted/?tab=sqlserver2014))
- [Datadog Windows Agent Guide (CLI)]([https://www.youtube.com/watch?v=yPYZpwSpKmA](https://docs.datadoghq.com/agent/basic_agent_usage/windows/?tab=commandline))

## Tips

*This section is optional and may be omitted.*

*Add tips and hints here to give students food for thought. Sample IoT tips:*

- IoTDevices can fail from a broken heart if they are not together with their thingamajig. Your device will display a broken heart emoji on its screen if this happens.
- An IoTDevice can have one or more thingamajigs attached which allow them to connect to multiple networks.

## Advanced Challenges (Optional)

*If you want, you may provide additional goals to this challenge for folks who are eager.*

*This section is optional and may be omitted.*

*Sample IoT advanced challenges:*

Too comfortable?  Eager to do more?  Try these additional challenges!

- Observe what happens if your IoTDevice is separated from its thingamajig.
- Configure your IoTDevice to connect to BOTH the mothership and IoTQueenBee at the same time.
