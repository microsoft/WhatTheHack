# Azure Networking - What The Hack - Info for coaches

## 0. Before you start

* Try to get participants to use code (PS or CLI)
* Make sure they have a way to share code, ideally via git
* If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
* Leave participants try designs even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
* **Make sure no one is left behind**
* For each challenge, you can ask the least participative members to describe what has been done and why
* Feel free to customize scenarios to match your participants' level: if they are too new to Azure, feel free to remove objectives. If they are too advanced, give them additional ones

These topics are not covered, and you might want to introduce them along the way depending on the participants interests:

* **IP addressing/subnetting**: if this is not clear, you might want to whiteboard this in the first scenario (hub and spoke), or have a participant explain to the others
* **NAT gateway/ALB outbound rules**: this could be discussed in the NVA scenario
* **NSGs**: complex NSG scenarios (like interaction with standard ALB, applying NSGs to both subnet and NIC, flog logs, etc) and ASGs are not covered in this FastHack. If the question comes up you could make them configure NSGs in the first scenario (hub and spoke)

## Challenges

- Challenge 0: **[Pre-requisites](00-Prereqs.md)**
   - Prepare your workstation to work with Azure
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
