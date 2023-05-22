# Stretch Thinking: Topical Discussions for Your Team

**[Home](./README.md)**

## Notes & Guidance

The purpose of the "Stretch Thinking" is for a coach to side-step into a topical concern, i.e., tease out a real-world scenario. These are helpful in furthering the students' education and subsequent training.  

These aren't challenges per se; rather, they are topics that you choose to bring up given a collective set of issues/concerns.  For example, this What The Hack doesn't have a challenge for managing Bicep linting, but the Coach's Solutions all have implemented a Bicep linting configuration.  Talking through the requirement for linting and showing an example will further their understanding of Bicep.  Think of these as 5-10 minute side-steps vs. long, drawn-out conversations.

## Linting, Errors, Warnings

Linting is a means to ensure code has the proper syntax and uses custom rules for authoring.  In the coach's solutions, a custom linting file named "bicepconfig.json" exists for each challenge.  You can use this for a side-step conversation on linting.

[Bicep Linting](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter)
[Bicep Custom Linting Rules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-admin-username-should-not-be-literal)

## Managing a Resources API versions

Managing the API versions of a resource, e.g., the '2022-09-01' at the end of 'Microsoft.Storage/storageAccounts@2022-09-01', can be difficult if not overly analyzed.  In this side conversation, you can discuss how to determine currently supported API versions of a resource provider, rules for how old of an API version is allowed, and the process to manage API versions moving forward.

[Azure resource providers and types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types)

## Deploying Bicep with GitHub Actions

Learning to author modules in Bicep that promote consistency and reuse is core to achieving Infrastructure as Code and it's equally important to think about how you can achieve CI/CD with Bicep.

In this side conversation, you can tease out how things like GitHub Actions fit into IaC and talk through some examples. This is an area to challenge the students beyond what is covered in the Hack.

[Deploying Bicep with GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)

### Opinionated Deployments

An "opinionated" deployment is one that the constraints are authored directly in a module or passed into a generic module from another source.  For example, a VM module could contain the allowed values for Linux distributions and their versions vs. the module will simply accept what is sent to it.  This gets into a design principle on how to manage opinionated modules especially when reuse is intended.

In this side conversation, discuss the design considerations for managing things like versions, accepted distros, etc.
