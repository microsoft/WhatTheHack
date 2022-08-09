# Challenge 03 -  Connect Network Virtual Appliance to SD WAN routers

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction
  
Now that we have a solid understanding of the functionality of Azure Route Server, you will integrate a simulated SDWAN environment to this solution.

## Description

Your Network Organization decided that Azure is amazing and want to establish communications with two different SDWAN Data Centers in separate geographic locations. They are advertising the exact same prefixes from both locations via BGP and they want to reach their On Premises Data Center. 
  
![ARS_SDWAN](/xxx-AzureRouteServer/Student/Resources/media/azurerouteserver-challenge3.png)
  
Please deploy the following scenareo:
- Establish two simulated SDWAN branches on different locations
- Carve out 3 non overlapping prefixes: Two of them will be advertised from your branches. The third one will only be advertised from one of them.  

  ***NOTE:** You may use the Cisco CSR 1000v templates for this challenge provided below.*

> [!IMPORTANT]
> SDWAN technologies are emerging and have a level of detail beyond the scope of this class. Just to give a very brief idea, they often use Azure as a transit infrastructure and run IPsec tunnels as an overlay amongst other protocols. They centralize control plane and management plane operations into different virtual components (v-manage, v-smart). For intent and purpose of this challenge, we will just create two separate Cisco routers on two separate Vnets without going into further complexity. 

  

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
