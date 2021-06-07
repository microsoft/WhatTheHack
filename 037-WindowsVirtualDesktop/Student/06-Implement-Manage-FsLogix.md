# Challenge 6: Addressing User Profiles with FSLogix

[< Previous Challenge](./05-Create-Configure-HostPools.md) - **[Home](../README.md)** - [Next Challenge >](./07-Install-Configure-Apps.md)

## Introduction

- FSLogix is the AVD user profile solution which allows yours to log onto any VM in the HostPool and maintain their user experience.  
- User Profiles are also a critical part of Disaster Recover planning.  
- Follow the FSLogix requirements & best practices.

## Description

Using the 3 Storage accounts that were created in Challenge 3, we now need deploy FSLogix and configure the User Profile Settings. Given the need for Disaster Recover and concerns of the profile data, there is a noted option for Cloud Cache that will need to be used.

- Configure the FSLogix clients
    - Japan Users do not use FSLogix because they have personal hostpools.  
    - Configure VHDLocations for US Users.
    - Configure Cloud Cache for UK Users.  
    - Optimize - Configure for VHDx | Configure Dynamic Disk | Replace local profile | set VHDx default size | Flip Flop directory name]
    - Use GPO Preference to add admins to the local FSLogix exclude groups
    - Use GPO Preference to add The correct users to the local FSLogix include groups

## Success Criteria

1. Configure FSLogix according to best practices  
2. Solution should allow users to access profile data if a region is unavailable
3. Configure FSLogix with GPO

## TIPS

Teams cache data can be large sometimes (4-5 GB) and customers may want it omitted it from the profile. User FSLogix redirections so TEAMS data is kept on the local system, not in the users profile.
