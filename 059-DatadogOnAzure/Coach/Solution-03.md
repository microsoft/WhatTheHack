# Challenge 03 - Monitoring Azure Virtual Machines - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

### Windows Agent Install Steps
For SQL server host - use Bastion to remotely connect to the host and run the updated powershell script. Make sure the student updates their API key!


- ``$ProgressPreference = 'SilentlyContinue'`` 
- ``wget "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi" -usebasicparsing -outfile .\ddagent.msi``
- ``Start-Process -Wait msiexec -ArgumentList '/qn /i ddagent.msi APIKEY="INSERT-YOUR-API-KEY-HERE" SITE="us3.datadoghq.com" TAGS="env:dev" DD_ENV=dev REBOOT=ReallySuppress ADDLOCAL="MainApplication,NPM" LOGS_ENABLED=true PROCESS_ENABLED=true CMD_PORT=6001 APPSEC_ENABLED=true'``
- ``$ProgressPreference = 'Continue'``

- For the IIS VM scaleset, add the script to the correct Azure blob storage location, the DELETE the VM instances. Azure will deploy two new VM instances to the scale set. You should see them appear in the Events page in Datadog when the hosts have come online and Datadog has been installed. 

### Dashboard Steps
* Navigate to the infrastructure list
* Click on a host
* Click on the host dashboard
* Clone the dashboard
* Add widgets to the dashboard:
  * Logs
  * System network
* Add a graph to the dashboard
  * Process top list
* Add template variables (top left) for the following tags:
  * `env`
  * `host`
  * `region`
* Then update each graph's `host` query section to instead reference the template variable. 
