# What The Hack - Azure Networking with Hub and Spoke

## Before you start

* Try to get participants to use code (PS or CLI)
* Make sure they have a way to share code, ideally via git
* If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
* Leave participants try designs even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
* **Make sure no one is left behind**
* For each challenge, you can ask the least participative members to describe what has been done and why
* Feel free to customize scenarios to match your participants' level: if they are too new to Azure, feel free to remove objectives. If they are too advanced, give them additional ones

These topics are not covered, and you might want to introduce them along the way depending on the participants interests:

* **IP addressing/subnetting**: if this is not clear, you might want to whiteboard this in the first scenario (hub and spoke), or have a participant explain to the others. You can use a web-based IP subnet calculator

## Coach Guides

- Challenge 1: **[Hub and spoke](01-HubNSpoke-basic.md)**
    - Configure a basic hub and spoke design with hybrid connectivity
- Challenge 2: **[Azure Firewall](02-AzFW.md)**
    - Fine tune your routing to send additional traffic flows through the firewall
- Challenge 3: **[Routing Troubleshooting](03-Asymmetric)**
    - Troubleshoot a routing problem introduced by a different admin
- Challenge 4: **[Application Gateway](04-AppGW.MD)**
    - Add an Application Gateway to the mix
- Challenge 5: **[PaaS Networking](05-Paas.md)**
    - Integrate Azure Web Apps and Azure SQL Databases with your hub and spoke design

## Deployment using Infrastructure-as-Code
The coaches solutions for this hack includes a deployment of the challenges written in Bicep.

For coaches, the infrastructure deployed in the solution can provide a quick reference architecture/lab for an approach to implementing the challenges.

For students, the automation presents a solution, which the students are generally expected to figure out on their own. However, there are a number of scenarios where providing a student with the Bicep files could be helpful:

* Bringing a student up to speed with the rest of the cohort
* Enabling students to focus on the network aspects of the hack, versus manual infrastructure deployment (especially when they are struggling with a less-relevant aspect)
* Quickly bringing a cohort of students up to a specific challenge (for example, enabling data-focused students to work with PaaS services and Private Endpoints, without having had to manually deploy the underlying infrastructure)
* Providing examples to students looking to implement the hack with IaC

**See [Bicep Solution Readme](./Solutions/bicep/README.md) for detail deployment process.**