# Challenge 01 - Migrate MongoDB to Azure Document DB online using Azure DocumentDB migration extension for VS Code

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

In this hack you will be getting hands-on experience using the Azure Document DB Migration Extension in Visual Studio Code to migrate the data from your source MongoDB to Azure Document DB. 

Azure DocumentDB is a great platform choice for MongoDB workloads in Azure because it gives you MongoDB API compatibility with a fully managed service experience. You can scale throughput and storage independently, improve availability with built-in high availability and optional multi-region distribution, and reduce operational overhead for patching, backups, and monitoring. The underlying DocumentDB engine is open source (MIT licensed), while the Azure-hosted experience adds managed operations plus integration with Azure security and governance capabilities for stronger reliability, compliance, and cost control.

## Prerequisites

You should have already completed the steps in [Challenge 0]()./Challenge-00.md) to set up your source MongoDB database and the sample application. 

## Description

In this challenge, you will install the Azure Document Migration extension in Visual Studio Code and then use it to perform the MongoDB migration. 

**NOTE:** If you are using GitHub Codespaces, the `az login` command will use a Device Code to login. If your organization's Azure policy prevents this, follow these steps first before you run the deployment:
- Open your [Codespace in Visual Studio Code Desktop](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
- From the terminal in Visual Studio Code, run these commands to login:
```
CODESPACES=false
az login
```
- Install the [Azure DocumentDB migration extension](https://aka.ms/azure-documentdb-migration-extension)
- Perform the following steps to create an instance of Azure DocumentDB in your Azure subscription
    - Open a New Terminal window in VS Code
    - Type the following commands to deploy Azure Document DB. 
    
    ```
    cd infra 
    ./deploy.sh --administratorLogin mflixadmin --administratorPassword <password>
    ```

    Optional: you can specify the `resourceGroupName` and `location` if you need to as arguments to the `deploy.sh` script as follows. ***Note***: It defaults to `rg-mflix-documentdb` and `eastus2` for those, respectively:
    ```
    cd infra 
    ./deploy.sh --resourceGroupName <your_resource_group_name> --location westus --administratorLogin mflixadmin --administratorPassword <password>
    ```



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

- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)

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
