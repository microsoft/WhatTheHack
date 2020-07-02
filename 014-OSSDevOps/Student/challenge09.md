# What the Hack: OSS DevOps 

## Challenge 09 - Monitoring: Generating and listening to application metrics
[Back](challenge08.md) // [Home](../readme.md)

### Introduction

Monitoring applications & application servers is an important part of the DevOps. It is important to continuously monitor applications and servers for application exceptions, server CPU & memory usage, or storage spikes. It is often desired to get notifications and/or alerts if CPU or memory usage goes up for a certain period of time or a service of your application stops responding so appropriate corrective actions can be taken to mitigate those failures or exceptions.

With monitoring, there are a number tools out there such Azure Application Insights, Azure Monitor, Nagios, New Relic, Prometheus and others. In this challenge, we will take a look at the Prometheus monitoring, a popular free & open-source project for monitoring services.

### Challenge

The tasks in this challenge are to:
1. Deploy a Prometheus instance
    * [**Hint**] Though it is possible to deploy Prometheus to VMs, most implementations of Prometheus server are done through containers. Use ACI will be an efficient way to deploy a Prometheus instance.
2. Setup application monitoring on the voting application and have those metrics be emmited to the deployed Prometheus instance.

### Success Criteria

The successfully complete this section deploy a the voting application and have its metrics be emitted to Prometheus.
   
[Back](challenge08.md) // [Home](../readme.md)