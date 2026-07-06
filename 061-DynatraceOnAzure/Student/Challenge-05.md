# Challenge 05 - Grail - Dashboards & Notebooks

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

 - Make sure you've meet all the success criteria for Challenge 0

## Pre-requisites (Optional)
None

## Introduction
Dynatrace offers multiple ways to visualize your Observability data.  One of those ways is [Dashboards](https://www.dynatrace.com/hub/detail/dashboards/).  With Dashboards you can:

- Query, visualize, and observe all your data stored in Grail.
- Write custom JavaScript with adhoc functions to fetch external data.
- Annotate all your visualizations with markdown to enrich them with context.
- Add variables to filter your results and make your dashboard dynamic.
- Several data and code snippets are available out of the box. Use them to get started.

Another powerful way you can visualize your observability data is via [Notebooks](https://www.dynatrace.com/hub/detail/notebooks/).  Notebooks  allows you to create powerful, data-driven documents for custom analytics. Here are some thing that Notebooks enables you to do:

- Query, analyze, and visualize all your security, observability, and business data such as logs, metrics, and events powered by  Grail.

- Predict future trends with embedded Davis forecast capabilities.

- Create and collaborate on interactive, data-driven, and persistent documents.

- Fetch and incorporate external data by running  [Dynatrace Functions](https://dt-url.net/functions-help).

- Interact with data; start drill-downs by sorting, filtering, and aggregation, or even trigger workflows.

- Annotate and add context with markdown.

## Description

### Objectives of this Challenge

- Use Notebooks to analyze observability data
- Build a sample dashboard from Grail data

### Tasks

* Create a dashboard and with an element to Query Grail. 
* Add the following grail
    ```bash
    fetch logs
    | filter cloud.provider == "azure"
    | summarize count(), by:{azure.resource.type}
    | sort `count()`, direction:"descending"

    ```
* [Download](https://raw.githubusercontent.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/grail/learner-scripts/AzureGrailWorkshop-Logs.json) a sample Notebook to analyze log data.  Upload that sample notebook to Notebooks app in your Dynatrace tenant.
* Follow the instructions in the notebook on how to analyze log data.
* [Download](https://raw.githubusercontent.com/dt-alliances-workshops/azure-modernization-dt-orders-setup/grail/learner-scripts/AzureGrailWorkshop-Metrics.json) a sample Notebook to analyze metric data.  Upload that sample notebook to Notebooks app in your Dynatrace tenant.
* Follow the instructions in the notebook on how to analyze metric data.




## Success Criteria
- Created a dashboard with DQL element to query log data
- Used the sample notebook to analyze azure log data
- Used the sample notebook to analyze azure metric data
## Learning Resources
- Want to know more about the Dynatrace Query Language? 🎓 [Learn DQL](https://dt-url.net/learndql) at the Dynatrace playground. 🎓

- If you want to go further and learn more about using DQL to refine queries in Notebooks, visit [Dynatrace Query Language](https://www.dynatrace.com/support/help/observe-and-explore/query-data/dynatrace-query-language).

