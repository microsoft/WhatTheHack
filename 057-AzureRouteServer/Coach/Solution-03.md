# Challenge 03 - Connect Network Virtual Appliance to an SDWAN environment - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance
- Please remind the students that SDWAN in this scenario will be represented with TWO different Simulated On Premises environments. SDWAN is a technology that most students will require licenses from a specific vendor and specific knowledge, which is not required for these testing purposes.
- The SDWAN environments will be simulated utilizing two separate VNets with Two different Cisco NVAs on each.
- Each Vnet needs to be created on a different Region and Resource Group than the main Hub and Spoke. These are not arbitrary; we want the closest Region to the Hub and Spoke to have preference over the other.
- The configuration templates are given to the student.
- Please make sure no Overlapping Address space is occupied on those two VNets and utilized on the Virtual Tunnel Interfaces within the Cisco NVAs. For example, do not utilize a Cisco VTI with 10.0.0.1 since Azure, is the first usable of a given subnet.
- Establish One IPSec tunnel from each of these two SDWAN simulated Cisco Virtual Appliances, to the Cisco CSR Central Virtual Appliance in the Hub Virtual Network.
- Establish BGP from each of these two SDWAN simulated Cisco Virtual Appliances to Cisco CSR Central Virtual Appliance in the Hub Virtual Network.
- Guide the Student through advertising identical address spaces from the two SDWAN Virtual Appliances via BGP. Students will need some guidance to understand how to configure the loopbacks to advertise such IPs, and how to configure route maps and ip access list to have better preference using BGP attributes. For example, you can have the student advertise 1.1.1.1/32 created as a loopback interface.
- First you might announce the same prefixes with Equal attributes and see how it reflects across the effective routes of the Hub and Spoke, on Premises. Also, please look at the Received and Advertised prefixes from the Route Server's perspective. Lastly, you may also check the routing table on the Virtual Appliance themselves.
- The main idea is that the closest Region to the Hub and Spoke is more desirable than the Region further away from the Hub and Spoke. In other words, manipulate the BGP attributes within the SDWAN NVAs to ensure the latter.
- Finally, look at the effective route tables from all the VMs on the Hub and Spoke Topology and help the student understand how Route Server installs the preferred route.
