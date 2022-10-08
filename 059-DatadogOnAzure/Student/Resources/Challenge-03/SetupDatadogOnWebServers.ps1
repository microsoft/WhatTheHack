# This script will be invoked by the automation script that runs when a new VM instance is created in the VM Scale Set.

# Modify this script to add code that configures Datadog on the web servers running in the VM Scale Set

# Download the Datadog agent
$ProgressPreference = 'SilentlyContinue'
wget "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi" -usebasicparsing -outfile .\ddagent.msi

# Install Datadog using the downloaded MSI file
# ACTION - Insert your own Datadog API Key
Start-Process -Wait msiexec -ArgumentList '/qn /i ddagent.msi APIKEY="INSERT-YOUR-API-KEY-HERE" SITE="us3.datadoghq.com" TAGS="team:platform" DD_ENV=dev REBOOT=ReallySuppress ADDLOCAL="MainApplication,NPM" LOGS_ENABLED=true PROCESS_ENABLED=true APPSEC_ENABLED=true'
$ProgressPreference = 'Continue'