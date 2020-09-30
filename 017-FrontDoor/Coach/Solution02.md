# Notes for Challenge 2 - Provision your Front Door

 [< Previous Challenge [1]](./Solution01.md) - **[Home](./README.md)** - [Next Challenge [3] >](./Solution03.md)

One of the things that can hinder people if they need coaching around how DNS works and creating DNS records.  The biggest hurtle for this challenge is setting up the two DNS names needed to have Front Door validate the domain and for the Front Door managed SSL flow to work (and traffic to go to Front Door for that matter).  Let's say their SiteName is XXXX:
- ARM Template deploys a Azure DNS Zone hosting XXXX.contosomasks.com 
- App Service is configured with www.XXXX.contosomasks.com, again done by ARM Template.
- First, they create the Front Door account with an example name of: ***BOB***
- First DNS Name they need to create in their Azure DNS Zone is the *"verify"* CNAME:
  - **afdverify.frontdoor** CNAME to afdverify.***BOB***.azurefd.net
  - This allows Front Door to verify you are really in control (aka if you can modify the Primary DNS of a domain, probably the right person to configure Front Door).
- Second DNS Name they need to create is the real one to direct traffic:
  - **frontdoor** CNAME to ***BOB***.azurefd.net
  - This sets up so Browsers can now hit the website thru Front Door
  - This is also the prereq for Front Door to generate a ***FREE*** SSL Certificate for them

For the logs, they have to setup a Log Analytics Workspace in that Resource Group and configure the Diagnostics Settings of the Front Door Resource to send all 3 items to that Log Analytics Workspace:
1. FrontdoorAccessLog
2. FrontdoorWebApplicationFirewallLog
3. AllMetrics

For querying it, when they click on "Logs" under Monitoring on the Front Door resource, the first query in the Examples is "Requests per hour" and gives you a nice graph showing things happening:

`AzureDiagnostics | where ResourceProvider == "MICROSOFT.NETWORK" and Category == "FrontdoorAccessLog" | summarize RequestCount = count() by bin(TimeGenerated, 1h), Resource | render timechart `

The point of doing this is to get logging setup (need it for WAF) and expose the fact, all traffic is going to be logged here.

The purpose of showing the side by side comparison of Non-Front Door vs Front Door using https://tools.keycdn.com/performance, is to demonstrate the dramatic Connect and TLS savings.  If someone asks why do they have to hit it a few times, we are doing a hyper accelerated implementation of Front Door to Production simulation.  Normally there is more than a few minutes prior to World Wide traffic.  Hitting it a few times verifies all the configuration is replicated to the 160+ Points of Presence and the AnyCAST Routing has propagated globally.

## Links
- [Create a Front Door for an App Service](https://docs.microsoft.com/en-us/azure/frontdoor/quickstart-create-front-door)
- [Custom Domain Name for Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-custom-domain)
- [SSL for Custom Domains in Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-custom-domain-https) - We are choosing Front Door managed.  You can bring your own certificate, but almost all cases this is so much better.  Great strong SSL certificate, auto renews, costs you nothing ....

## Solution Scripts (PowerShell with AZ CLI)

#### Create an Azure Front Door

`az network front-door create --name BOB --resource-group rg-MyResourceGroup --backend-address contosomasks-XXXX.azurewebsites.net`

