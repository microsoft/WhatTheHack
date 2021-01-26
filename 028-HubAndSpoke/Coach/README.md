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

## Hub and Spoke WTH

Gotchas:

* There are multiple technologies that participants can use to simulate an onprem VPN site:
  * Azure VPN Gateways: make sure that they do not get confused with the VNet gateways and Local Network Gateways. Make sure they use local network gateways (instead of vnet-to-vnet connections), so that they understand the process involved in configuring S2S tunnels
  * Windows Server: good enough for all scenarios, if the participants are familiar with Windows
  * Linux and StrongSwan: good enough for all scenarios, if the participants are familiar with StrongSwan
  * Cisco CSR: the student resources bring an example of how to deploy and configure a Cisco CSR 1000v to simulate an onprem site. You can opt to deploy it in parallel so that they only see Azure.
* You might inject additional prefixes from the S2S tunnel, so that they are hinted to use the `Disable BGP Propagation` route table checkbox
* Participants might introduce asymmetric routing, especially if configuring a route table in the spoke with a route for the whole hub vnet pointing at the AzFW VIP (SNATted traffic from the Internet would break)
* Discuss implications of poor IP address planning
* Using another VNG to simulate onprem might be confusing, using Windows RRAS to simulate onprem might be more intuitive. However that might be hard to swallow for participants  without Windows Server experience
* Participants might get confused with the order in which network rules and application rules are applied

Additional options:

* Include microsegmentation (intra-subnet traffic sent to firewall)
