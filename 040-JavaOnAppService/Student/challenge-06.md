# Challenge 6: It's all about the scale

[< Previous Challenge](./challenge-05.md) - **[Home](../README.md)**

## Introduction

Azure App Service is a scalable platform, it can automatically scale out when there's unexpected load. But it has to be configured properly to know when to scale out.

## Description

Configure App Service to scale out to multiple instances if the CPU usage goes beyond 60%. Generate some load using your favourite tool and observe the number of instances going up, and down when the load is terminated.

## Success Criteria

1. Verify that the number of App Service instances increases when there's a large amount of requests, and also decreases when the load reduces.
1. No files should be modified for this challenge

## Tips

There's a multitude of different ways to generate requests, you could use the included JMeter file, or run an [ACI container](https://docs.microsoft.com/en-us/azure/container-instances/) with [wrk](https://hub.docker.com/r/bootjp/wrk2) to generate the load.

## Learning Resources

- [Scale out rules](https://docs.microsoft.com/en-us/azure/azure-monitor/autoscale/autoscale-get-started)
- [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/)
- [Running wrk with Docker](https://hub.docker.com/r/bootjp/wrk2)
