# Challenge 2 - Enable BGP

[< Previous Challenge](./01-lab_setup.md) - **[Home](./README.md)** - [Next Challenge >](./03-aspath_prepending.md)

## Notes and Guidance

There are three steps to this challenge:

1. Connecting VNG1 and CSR3
2. Connecting VNG2 and CSR4
3. Connecting the rest of the adjacencies

It is recommended start with step 1, and show the main diagnostic commands to the participants. Step 2 will show them the added complexity of active/active gateways.

All IPsec tunnels are already up, but BGP is not enabled. On Azure, participants need to figure out the different places where BGP needs to be configured (VNet Gateway, Local Gateway, connection).

After that, they can split in different subgroups to complete the remaining adjacencies.

There is a expected problem with routes in the iBGP adjacency between CSR3 and CSR4, where routes will not have the correct next hop IP address, and as a consequence VMs will not have connectivity. The fix is adding the `next-hop-self` configuration to the neighbor definitions in CSR3 and CSR4.

## Solution Guides

1. [Connecting VNG1 and CSR3](./Solutions/02.1_Solution.md)
2. [Connecting VNG2 and CSR4](./Solutions/02.2_Solution.md)
3. [Connecting the rest of the adjacencies](./Solutions/02.3_Solution.md)

