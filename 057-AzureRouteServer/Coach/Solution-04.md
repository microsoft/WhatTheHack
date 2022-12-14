# Challenge 04 - Introduce High Availability with Central Network Virtual Appliances - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)**
           
## Notes & Guidance

- First instance of Central NVA has been deployed in challange 01. 
- Deploy another instance for the purpose of High Availability.
- Use same "Hub" Azure Virtual network but add two new subnets.
- Establish BGP Peering with new NVA using cheat sheet made available in the challange 02 section.
- Setup Internal Load Balancer.
- Update Route advertisements as necessary. 
- Internal Load Balancers are required for traffic symmetry. 
