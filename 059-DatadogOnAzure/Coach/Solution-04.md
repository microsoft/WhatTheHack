# Challenge 04 - Datadog for Applications - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)**

## Notes & Guidance

The answer for this challenge can be exported as a Datadog Notebook with the saved queries and a dashboard definition. 
  
### Steps for Synthetics
  - Navigate to [Synthetics](https://us3.datadoghq.com/synthetics/tests)
    - Create new tests for:
      - [ICMP/Ping](https://us3.datadoghq.com/synthetics/create?subtype=icmp)
      - [API/HTTP](https://us3.datadoghq.com/synthetics/create?subtype=http)
      - [Browser test](https://us3.datadoghq.com/synthetics/browser/create)


### Server-Side Telemetry
  - Make sure the Agent on the IIS scaleset has APM enabled (default) and that the following tags were added at install-time:
    - env (environment) e.g.: `env:dev`
    - version, `version=1.0`
    - service, `service=eshopweb`
  - Add IIS logging config
```yaml
init_config:


instances:
  - host: .
    tags:
      - service:eshopweb
      - env:dev
      - version:1
    sites:
      - https://eshopwebpage (public IP address of virtual machine scaleset)
```
  
### Enable RUM

Navigate to [RUM setup page](https://us3.datadoghq.com/rum/)
  - Create a new application
  - Choose JS
  - Give it the name "eshopweb"
  - Click "Create New RUM Application"
  - Choose "CDN Async"
  - set the "dd.env" tag to `dev` on the top-right of the form (it updates the code on the left)
  - add a tag for version, set it to `1` in the code on the left
  - Copy the code to your clipboard (it contains `cliendToken` and `applicationId`)
  - On the Visual Studio VM via Bastion, add the js code to the index.cshtml page 
  - Run a new build via powershell script
  - Come back to the RUM application setup page
  - Click "explore user sessions" once the waiting for data spinner stops
