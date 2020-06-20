
# Challenge 11 - Implement Auto Scaling

[< Previous Challenge](./ARM-Challenge-10.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-12.md)

## Introduction

The goals of this challenge include understanding:
- ARM allows declarative management of policies and actions
- How to configure auto-scaling of VMs

## Description

- Extend the ARM template to include an auto scaling policy.  The policy requirements should be:
    - Scale up when CPU performance hits 90%
    - Scale back down when CPU performance hits 30%
    - Scale in single VM increments
    - Enforce a 1 minute cool down between scale events
        
## Success Criteria

1. Verify that the auto-scale policy is set correctly in the Azure portal
