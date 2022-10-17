# This script will be invoked by the automation script that runs when a new VM instance is created in the VM Scale Set.

# Modify this script to add code that configures Datadog on the web servers running in the VM Scale Set

# Download the Datadog agent
$ProgressPreference = 'SilentlyContinue'
wget "https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi" -usebasicparsing -outfile .\ddagent.msi

# Install Datadog using the downloaded MSI file
# ACTION - Insert your own Datadog API Key
Start-Process -Wait msiexec -ArgumentList '/qn /i ddagent.msi APIKEY="INSERT-YOUR-API-KEY-HERE" SITE="us3.datadoghq.com" TAGS="team:platform" DD_ENV=dev REBOOT=ReallySuppress ADDLOCAL="MainApplication,NPM" LOGS_ENABLED=true PROCESS_ENABLED=true APPSEC_ENABLED=true'
$ProgressPreference = 'Continue'

# Download .NET Tracer v1.13x64 .msi
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Invoke-WebRequest https://github.com/DataDog/dd-trace-dotnet/releases/download/v1.13.0/datadog-dotnet-apm-1.13.0-x64.msi -OutFile c:\datadog-dotnet-apm-1.13.0-x64.msi)

# Start .NET Tracer v1.13x64
(Start-Process -Wait msiexec -ArgumentList '/qn /i c:\datadog-dotnet-apm-1.13.0-x64.msi')

# Configure win32_event_log 
 echo "init_config:
instances:
    - type:
         - Information
         - Critical
         - Error
         - Warning
         - Information
         - Audit Failure
         - Audit Success
      log_file:
         - Application
         - System
         - Security
         - Application
         - Setup

logs:
  - type: windows_event
    channel_path: Application
    source: Application
    service: Application
    sourcecategory: windowsevent

  - type: windows_event
    channel_path: Security
    source: Security
    service: Security
    sourcecategory: windowsevent

  - type: windows_event
    channel_path: System
    source: System
    service: System
    sourcecategory: windowsevent

  - type: file
    path: C:\inetpub\logs\LogFiles\W3SVC1\u_ex*
    service: eshoponweb
    source: iis

  - type: windows_event
    channel_path: Setup
    source: Setup
    service: Setup
    sourcecategory: windowsevent" > C:\ProgramData\Datadog\conf.d\win32_event_log.d\conf.yaml 

[String[]] $v = @("COR_ENABLE_PROFILING=1", "COR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}","CORECLR_ENABLE_PROFILING=1", "CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}", "DD_TRACE_ANALYTICS_ENABLED=true", "DD_AspNet_ENABLED=true", "DD_LOGS_INJECTION=true")
Set-ItemProperty HKLM:SYSTEM\CurrentControlSet\Services\W3SVC -Name Environment -Value $v
Set-ItemProperty HKLM:SYSTEM\CurrentControlSet\Services\WAS -Name Environment -Value $v

net stop was /y
net start w3svc 

& "$env:ProgramFiles\Datadog\Datadog Agent\bin\agent.exe" restart-service
