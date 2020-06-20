# Challenge 8 - SSH to your Highly Available VMs

[< Previous Challenge](./ARM-Challenge-07.md) - [Home](../readme.md) - [Next Challenge>](./ARM-Challenge-09.md)

## Introduction

Once your virtual machines are deployed behind a Load Balancer, the way you access them is different now that they share the same public IP address on the Load Balancer.

The goals for this challenge include understanding:
+ Network access policies

## Description

Extend your ARM template to configure the Load Balancer to enable SSH access to the backend virtual machines

## Success Criteria

1. Verify you can SSH to each of your virtual machines