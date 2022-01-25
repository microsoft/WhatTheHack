# Challenge 1: Building a basic Hub And Spoke topology 

**[Home](README.md)** - [Next Challenge >](./02-AzFW.md)

## Notes and Guidance

This challenge involves configuring Azure, as well as simulating a branch with an onprem VPN device. The focus of the exercise is the Azure part, but we believe that it is very useful for participants being able to build end-to-end environments.

If as a coach you decide to remove the onprem side of the challenge, you might want to deploy the VPN gateway of your choice in your own subscription, and simulate that you are the onprem Network Operations team.

Additional remarks:

* There are multiple technologies that participants can use to simulate an onprem VPN site:
  * Azure VPN Gateways: make sure that they do not get confused with the VNet gateways and Local Network Gateways. Make sure they use local network gateways (instead of vnet-to-vnet connections), so that they understand the process involved in configuring S2S tunnels
  * Windows Server: good enough for all scenarios, if the participants are familiar with Windows
  * Linux and StrongSwan: good enough for all scenarios, if the participants are familiar with StrongSwan
  * Cisco CSR: the student resources bring an example of how to deploy and configure a Cisco CSR 1000v to simulate an onprem site [here](../Student/resources/csr.md ).
    * Branch VM subnet needs to have UDR in place to properly route traffic destined to the hub/spoke via CSR.
    * Add system route within CSR to encompass VNET address space (ip route 172.16.0.0 255.255.0.0 172.16.0.1) and distribute route via BGP (network 172.16.0.0 mask 255.255.0.0)
    * Associate NSG with CSR subnet and ensure inbound/outbound rules are created to allow inbound traffic to be forwarded by appliance. 
* Using another VNG to simulate onprem might be confusing, using Windows RRAS to simulate onprem might be more intuitive. However that might be hard to swallow for participants without Windows Server experience
* You might inject additional prefixes from the S2S tunnel, so that they are hinted to use the `Disable Gateway Propagation` route table checkbox, and their solution is actually surviving a change in the onprem prefix
* Ensure that NVA NIC has traffic forwarding enabled
