# Tailwind Reports

Tailwind has some departments that need to know when SKU quantities have been updated. To address that, Tailwind created a Serverless Function which runs every night at midnight and checks the SQL Server Inventory table for any SKU quantities that have been updated in the last 24 hours. If any are found, it sends an email using Azure Functions SendGrid bindings.

**Note:** Currently this project only works with SQL Server.

## Running Locally

### Setup SendGrid

This function uses SendGrid to send out emails. You will need to open a free account on SendGrid and get an API key. You will also need to create a Transaction Template in SendGrid which will format the data for the report. You can simply copy and paste in the markup from the SENDGRID_TEMPLATE.html file in this project.

### Setup Project

Clone this repo and install dependencies

```
npm install
```

Update the SendGrid Functions extension

```
func extensions install
```

Add the following variables to your `local.settings.json` file...

```
"AzureWebJobsStorage": "{Storage Account Connection String}",
"FUNCTIONS_WORKER_RUNTIME": "node",
"SQL_USERNAME": "{SQL Server User Name}",
"SQL_PASSWORD": "{SQL Server Password}",
"SQL_SERVER": "{Fully Qualified Server Name}",
"SQL_DATABASE": "{Name Of Database With Inventory Table}",
"SENDGRID_API_KEY": "{API Key From SendGrid}",
"SENDGRID_TEMPLATE_ID": "{SendGrid Template ID}",
"RECIPIENT_EMAIL": "{To Email Address}",
"SENDER_EMAIL": "{From Email Address}"
```

Start the local Functions runtime. The timer trigger runs every 24 hours, so you can manually execute the report by navigating to http://localhost:7071/api/RunCreateReport.

### Modifying To/From/Subject

For the sender, you can use `tailwind.reports@tailwind.com`. That address does not exist, but SendGrid will still send with it. You may consider swapping that out for something else. To send to multiple email addresses, separate addresses with a comma in the "to" field.

## Deploying To Azure
