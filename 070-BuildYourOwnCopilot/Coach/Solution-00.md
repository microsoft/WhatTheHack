# Challenge 00 - The Landing Before the Launch - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Challenge-00 is all about helping the student deploy resources to Azure in preparation for the launch of the POC. The student will deploy services into the landing zone in preparation for the launch of the POC.

> [!TIP]
> If the student does not see data in the `product` and `customer` containers in Azure Cosmos DB, they should try re-running the `postdeployment` `azd` hook. To do this, they can execute the following command in the terminal: `azd hooks run postdeploy`.

### Coach solutions

In the Coach solution folders, each challenge has both a `solution` and `starter` folder. These folders contain snapshots of where the students should be starting out in that challenge (`starter` folder) and where they should end up at the end of the challenge (`solution` folder). If you want to run the fully completed hackathon, then you should run from the `solution` folder in the final challenge folder (`challenge-5`).
