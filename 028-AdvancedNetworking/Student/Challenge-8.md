Challenge 8 - Azure Private Link Service
< Previous Challenge - Home


Pre-requisites
Before you start this challenge, ensure you have completed Challenge-7.


Description
Contoso Payment Solutions provides SaaS service to it customers. One of the challenges is with with IP addressing conflict with these customers IP ranges. For customers hosted in Azure, Contoso is looking for a way to avoid such conflicts and simplify access to it services.


For this challenge:

Create another virtual network to simulate Contoso's client environment. Add a test virtual machine. The client network is using the same IP address range as Contoso.

Create a private connectivity to the Payments Solution service.

No public access to the service should be allowed from the client's server.


Success Criteria
At the end of this challenge, you should be able to verify the following:

The client should be able to successfully access the Payments application.

The client should be able to resolve Contoso's service to a private IP address.


Learning Resources
Azure Private Link
