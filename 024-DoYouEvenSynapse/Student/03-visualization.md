# Challenge 3: Visualization

[< Previous Challenge](./02-load-data.md) - **[Home](../README.md)** - [Next Challenge >](./04-incrementals.md)

## Introduction
I'm going to need to see that TPS report...

## Description
The executive board needs visuals tools to run analysis.  

You will need to create reports and/or dashboard to meet their requirements.  You can also include additional visuals to provide unanticipated insights or decision-making support.

Your visualization tools should be able to connect to the database/warehouse loaded in Challenge 2 and produce visuals that address these requirements:

Lifter Performance/Participation Perspective
- Show a listing of the Top 20 lifters at meets in the past 1 year, as measured by their wilks score from the meet. Default view can be based on all lifters, but it should be possible filer by sex, federation, and country.  It should also be possible to filter on Event type; the default filter should be SBD (Full Power) and BD (Benchpress, Deadlift) as these are the most common scored events.
- Show a listing of lifters with the longest participation period in the sport.  In other words, calculate the time between the lifter’s first and most recent Meet, and rank in descending order.  Call this list the Commitment Leaderboard.  Default view can be based on all lifters, but it should be possible filer by sex, federation, and country.

Sport Management Perspective (analysis oriented to healthy and growing organization)
- Show meets per year over time
- Show lifters participating per year over time
- Show meets and participants by federation
- Show meets and participants by country, over time
- Be creative in defining other visual analysis to present that would help Federation executives understand activity and trends in the sport.

![Example Visual](../Images/Leaderboard.png)

## Success Criteria
- Explained the team's choice of visualization tool
- Shown the coach (your executive) some of the visuals they can use in their next board meeting
- Demonstrate the ability to filter your visualizations
- A generated report in a desktop app is the minimum requirement
- Deployed reports and/or dashboards to the Power BI cloud service for broader access.

## Learning Resources
- [Microsoft Power BI](https://powerbi.microsoft.com/en-us/)
- [Data sources in Power BI Desktop](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-data-sources)
- [Create reports and dashboards in Power BI](https://docs.microsoft.com/en-us/power-bi/create-reports/)
- [Use DirectQuery in Power BI Desktop](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-use-directquery)
- [What is the Power BI service?](https://docs.microsoft.com/en-us/power-bi/fundamentals/power-bi-service-overview)
- [Introduction to dashboards for Power BI designers](https://docs.microsoft.com/en-us/power-bi/create-reports/service-dashboards)
