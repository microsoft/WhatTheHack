# Challenge 03: Godzilla takes out an Azure region! - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

In this Challenge, students will simulate a region failure. 

This can be done via the following: 
- NSG and blocking port 8081, 
- Chaos Mesh's POD failures set to all PODs in a region
- VMSS fault and selecting all nodes in a region

Traffic manager is the solution.  
- Verify students installed the application in WestUS and EastUS.  
- Routing method = Performance
- Configuration profile needs to be created
 - DNS TTL = 1
 - Protocol = Http
 - Port = 8081
 - Path = /pizzeria/
 - Probing interval = 10
 - Tolerated number of failures = 3
 - Probe timeout = 5
 
Use GeoPeeker to visualize multi-region DNS resolution https://GeoPeeker.com/home/default
