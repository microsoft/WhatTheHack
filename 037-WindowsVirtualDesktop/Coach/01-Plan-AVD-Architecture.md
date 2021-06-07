# Challenge 1: Design the AVD Architecture

[< Previous Challenge](./00-Pre-Reqs.md) - **[Home](./README.md)** - [Next Challenge>](./02-Implement-Manage-Network.md)

## Notes & Guidance

- Confirm students have followed the pre-req guide -> [Pre-reqs](./00-Pre-Reqs.md)  
Not strictly required for this session as this is just planning but will be needed for further challenges
- This challenge is to Plan the AVD deployment.  Students may need to be prompted to check the Scenario in the resources section.  Encourage them to consider all the requirements, both for the PoC but also for future deployment.  
Make sure they are designing with scale in mind.
- Ensure the following topics are considered in the proposed design:
    - Host Pool
        - Host pools architecture:
            - Types of Host Pools
                - Pooled  
                - Remote App  
                - Personal  
            - Reconfigure location for the Azure Virtual Desktop metadata  
        - Session Host VMs:
            - Recommend an operating system for Azure Virtual Desktop implementation.
            - Calculate and recommend a configuration for performance requirements.
            - Calculate and recommend a configuration for Azure Virtual Machine capacity requirements.
            - Anti-Virus Strategy
                - Example: Microsoft Defender  
    -  FSLogix
        - Recommend an appropriate storage solution (including Azure NetApp Files versus Azure Files).
        - Plan for user profiles.
    - Client Deployment
        - plan for Azure Virtual Desktop client deployment
            - Which client to use
                - Features and benefits  
                - Email Discovery  
                - How to Deploy
                - How to update
    - AVD Roles
        - **NOTE:** Premise of Least privilege user/group security model  
        - FSLogix local groups for include/exclude.
        - Local session host groups / GPO based group management.
        - Plan Identity Security  
            - Multi-Factor Auth  
            - Conditional Access  
            - Single-SignOn  
            - Smart Card Auth
        - AVD RBAC Assignments  
            - HostPool Management  
            - User Session Operations  
            - VM Management  



- **Recommended solution:** subsequent challenges are designed with the following configuration in mind (check resources section for further details)
    - Host Pool & User breakout:
        - Field in UK
            - 2000 pooled
            - Remote app only
            - Windows Server 2019
        - Developers Japan  
            - 1000 personal  
            - Windows 10 Enterprise  
        - Office workers US
            - 2000 pooled  
            - Windows 10 Multi-Session
    - Network:
        - Include discussion on network and why  
        - Hub East US
        - Spoke East US, UK South and Japan West
    - Also see suggested architecture diagram for guidance
    - For Storage, as long as they can justify the design, either NetApp or Az files is appropriate - most students won't be whitelisted for NetApp though, so considering this limitation their deployment will probably use AZ Files.
    - **NOTE:** Monitoring and BCDR are considered in seperate challenges (8 and 10) so depth design decisions don't need to be covered in this challenge, but they might inform the overall design decisions (eg storage replication type)
