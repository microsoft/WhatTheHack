# Challenge 06 - Stress & Multi-region Testing

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Pre-requisites (Optional)

*Include any technical pre-requisites needed for this challenge.  Typically, it is completion of one or more of the previous challenges if there is a dependency.*

**- Lorem ipsum dolor sit amet, consectetur adipiscing elit.**

**- Fusce commodo nulla elit, vitae scelerisque lorem maximus eu.** 

**- Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.**

**- Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.**

## Introduction (Optional)

Unlike load testing, which ensures that a system can handle what it's designed to handle, stress testing focuses on overloading the system until it breaks. A stress test determines how stable a system is and its ability to withstand extreme increases in load. It does this by testing the maximum number requests from another service (for example) that a system can handle at a given time before performance is compromised and fails. Find this maximum to understand what kind of load the current environment can adequately support.
    
Determine the maximum demand you want to place on memory, CPU, and disk IOPS. Once a stress test has been performed, you will know the maximum supported load and an operational margin. **It is best to choose an operational threshold so that scaling can be performed before the threshold has been reached.**

Once you determine an acceptable operational margin and response time under typical loads, verify that the environment is configured adequately. To do this, make sure the SKUs that you selected are based on the desired margins. Be careful to stay as close as possible to your margins. Allocating too much can increase costs and maintenance unnecessarily; allocating too few can result in poor user experience.

In addition to stress testing through increased load, you can stress test by reducing resources to identify what happens when the machine runs out of memory. You can also stress test by increasing latency (e.g., the database takes 10x time to reply, writes to storage takes 10x longer, etc.).

A multiregion architecture can provide higher availability than deploying to a single region. If a regional outage affects the primary region, you can use something like [Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview) to route traffic to the secondary region. This architecture can also help if an individual subsystem of the application fails…assuming you are replicating any relevant data stores across regions. 

Test the amount of time it would take for users to be rerouted to the paired region so that the region doesn't fail. Typically, a planned test failover can help determine how much time would be required to fully scale to support the redirected load.

## Description

- Create a new set of test scripts or parameters and run a stress test
- Identify the bottlenecks and breakpoints of the application under stress
- Decide whether to add the steps needed to remediate to the backlog #devops

## Success Criteria

*Success criteria goes here. This is a list of things an coach can verfiy to prove the attendee has successfully completed the challenge.*

**- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce commodo nulla elit, vitae scelerisque lorem maximus eu. Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.**

**- Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus. Etiam rutrum purus non eleifend lacinia.**

**- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis vestibulum risus. Maecenas eu eros sit amet ligula consectetur pellentesque vel quis nisi.**

## Learning Resources

[Stress testing](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/performance-test#stress-testing)

## Tips (Optional)

*Add tips and hints here to give students food for thought.*

**- Lorem ipsum dolor sit amet, consectetur adipiscing elit.**

**- Fusce commodo nulla elit, vitae scelerisque lorem maximus eu.** 

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

**- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce commodo nulla elit, vitae scelerisque lorem maximus eu. Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo. Vivamus venenatis accumsan neque non lacinia.**

**- Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus. Etiam rutrum purus non eleifend lacinia. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis vestibulum risus. Maecenas eu eros sit amet ligula consectetur pellentesque vel quis nisi.**
