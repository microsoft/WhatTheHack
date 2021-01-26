# What the Hack - Azure Networking Hub and Spoke

## Objectives

Please make sure that your deployment meets these objectives:

1. Deploy a hub and spoke network with at least 2 spokes. For the spoke names you can leverage spoke1-web and spoke2-web for example.
2. Simulate an onprem location by leveraging a VNet and connect it to the hub by using a solution capable of terminating an IPSEC (VPN) tunnel
3. Connect your simulated onprem location to your hub and spoke network.
4. Demonstrate connectivity between a VM in one of the spokes and the onprem location
5. Deploy an Azure Firewall to ensure spokes can communicate with each other, as well as to filter outbound traffic to the Internet
6. Place a web server in each spoke (at least 2 spokes). As web page you can use something like [this](https://github.com/jelledruyts/InspectorGadget) (.netcore)
7. Demonstrate spoke-to-spoke communication
8. Deploy a test VM in the hub (hub-test), show that traffic from hub-test to the spoke1-web and spoke2-web goes over AzFW
9. Demonstrate outbound Internet traffic from spoke1-web goes over AzFW by showing logs
10. Demonstrate access to the web server in spoke1-web or spoke2-web from the Internet

## Relevant links

* [Virtual Network peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
* [Hub and Spoke topology in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
* [What is Azure Firewall](https://docs.microsoft.com/azure/firewall/overview)
* [What is VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways)
* [Create a Site-to-Site connection in the Azure portal](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal)
* Example troubleshooting pages that can easily be deployed on the web platform of your choice:
  * [Inspector Gadget](https://github.com/jelledruyts/InspectorGadget) (.netcore)
  * [whoami](https://github.com/erjosito/whoami/tree/master/api-vm) (python/flask)
  * [KUARD](https://github.com/kubernetes-up-and-running/kuard) (container)
