# Notes for Challenge 3 - Provision a Web Application Firewall (WAF)

 [< Previous Challenge [2]](./Solution02.md) - **[Home](./README.md)** - [Next Challenge [4] >](./Solution04.md)


Only from a time perspective does the challenge specifies to mark the WAF Policy into Prevention mode from the start.  In normal circumstances, this is **SUPER DANGEROUS**.  WAF Rules cover various patterns that over the years and years web traffic has be subverted.  Sometimes the approaches of the past generated traffic patterns that are actually "OK" for some websites.  Watching in Detection mode is extremely important to be able to evaluate the effectiveness and/or over aggressiveness of each of the rules.

A really popular strategy is that, after an initial amount of traffic goes thru a rule set, is to set rules in "Log" mode and flip the Policy into Prevention.  This allows a more granular approach to enable WAF rules.  

We running `w3af` to generate simulate bad traffic against Front Door to be able to show how fo find malicious traffic.  **REMEMBER** It takes times (5 minutes or so) after a Diagnostics Settings being created for it to be logging.  And there is another delay have logs appear after the hits.  It's really important that people see logs in the Challenge 1 before starting Challenge 2.  The goal isn't to learn how to use `w3af` :).  Help them out as much as needed to get it to run.

We use https://tools.keycdn.com/performance to show the geo-blocking is effective.

## Links
- [Create a Front Door WAF Policy](https://docs.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)
  
## Solution Scripts (PowerShell with AZ CLI)

#### Create WAF Policy with Default Rule Set and Only allow US

```
az network front-door waf-policy create --name wwwWAFPolicy --resource-group rg-MyResourceGroup --mode Detection

az network front-door waf-policy rule create --action Block --policy-name wwwWAFPolicy --name OnlyUS --rule-type MatchRule --priority 100 --resource-group rg-MyResourceGroup --defer

az network front-door waf-policy rule match-condition add --match-variable RemoteAddr --name OnlyUS --operator GeoMatch --policy-name wwwWAFPolicy --resource-group rg-MyResourceGroup --values US --negate true

$rules = az network front-door waf-policy managed-rule-definition list | out-string | convertfrom-json

$defRule = $rules |? { $_.name -eq 'DefaultRuleSet_1.0' }

az network front-door waf-policy managed-rules add --policy-name wwwWAFPolicy --resource-group rg-MyResourceGroup --type $defRule.ruleSetType --version $defRule.ruleSetVersion
```

(There isn't an Azure CLI command to Update a Front Door Frontend, needs to be done thru Front End Design => Frontends => Enable WAF)

#### Kusto Query to show blocked rules and associated counts

```
AzureDiagnostics 
| where Category == 'FrontdoorWebApplicationFirewallLog'
| where action_s == 'Block'
| summarize count() by  ruleName_s 
| order by count_
```