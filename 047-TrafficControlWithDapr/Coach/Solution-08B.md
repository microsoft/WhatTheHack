# Challenge 8 - Dapr-enabled Services running in Azure Container Apps (ACA) - Coach's Guide

[< Previous Challenge](./Solution-07.md) - **[Home](./README.md)**

## Notes & Guidance

In this challenge, you're going to deploy the Dapr-enabled services you have written locally to an [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) service.

![architecture](../images/Challenge-08/architecture-aca.png)

### Challenge goals

To complete this challenge, you must reach the following goals:

- Successfully deploy all 3 services (`VehicleRegistrationService`, `TrafficControlService` & `FineCollectionService`) to an ACA service.
- Successfully run the Simulation service locally that connects to your ACA-hosted services

### Step 1: Update all port numbers & host names

By default, Dapr sidecars run on port 3500 when deployed to ACA. This means you will need to change the port numbers in the `FineCollectionService` & `TrafficControlService` class files to port 3500 for the calls to Dapr when deploying to the ACA cluster.

Look in the following files and make changes as appropriate.

- `Resources/FineCollectionService/Proxies/VehicleRegistrationService.cs`
- `Resources/TrafficControlService/Controllers/TrafficController.cs`

Also update the host name for each service (in the `Program.cs` file) from `http://localhost` to `http://*` as this will allow the Kestrel server to bind to 0.0.0.0 instead of 127.0.0.1. This is needed to ensure the health probes work in Kubernetes.

- [Update Host Name](https://miuv.blog/2021/12/08/debugging-k8s-connection-refused/)

### Step 2: Modify the FineCollectionService to subscribe to the `collectfine` topic programmatically

Dapr on ACA (at this time) doesn't support declarative pub/sub subscriptions, so you will need to modify the `FineCollectionService` to subscribe to the `collectfine` topic programmatically using the Dapr SDK.

1.  Modify the `FineCollectionService/Startup.cs` file similar to the example below.

    ```csharp
    public void ConfigureServices(IServiceCollection services)
    {
      services.AddSingleton<IFineCalculator, HardCodedFineCalculator>();
      services.AddHttpClient();
      services.AddSingleton<VehicleRegistrationService>();
      services.AddHealthChecks();
      services.AddControllers().AddDapr(); //<-- add this line
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }

      app.UseRouting();

      app.UseCloudEvents();  //<-- add this line

      app.UseEndpoints(endpoints =>
      {
        endpoints.MapHealthChecks("/healthz");
        endpoints.MapSubscribeHandler();  //<-- add this line
        endpoints.MapControllers();
      });
    }
    ```

1.  Modify the `FineCollectionService/Controllers/CollectionController.cs` file similar to the example below.

    ```csharp
    using Dapr.Client; //<-- add this line

    namespace FineCollectionService.Controllers
    {
      [ApiController]
      [Route("")]
      public class CollectionController : ControllerBase
      {
        ...
          if (_fineCalculatorLicenseKey == null)
          {
            var response = _httpClient.GetFromJsonAsync<LicenseKeySecret>("http://localhost:3500/v1.0/secrets/azurekeyvault/license-key").Result; //<-- change this line
            _fineCalculatorLicenseKey = response.LicenseKey;
          }
        }

        [Dapr.Topic("pub-sub", "collectfine")] //<-- add this line
        [Route("collectfine")]
        [HttpPost()]
        public async Task<ActionResult> CollectFine(SpeedingViolation speedingViolation)
        {
          decimal fine = _fineCalculator.CalculateFine(_fineCalculatorLicenseKey, speedingViolation.ViolationInKmh);
        ...
    ```

### Step 3: Build container images for each service & upload to Azure Container Registry

You will need to build these services, create a Docker container image that has this source code baked into it and then upload to an Azure Container Registry. The easiest way to do that is to use [ACR tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview).

1.  Navigate to the `Resources/VehicleRegistrationService` directory & use the Azure Container Registry task to build your image from source.

    ```shell
    az acr build --registry <container-registry-name> --image vehicleregistrationservice:assignment08 .
    ```

1.  Navigate to the `Resources/TrafficControlService` directory & use the Azure Container Registry task to build your image from source.

    ```shell
    az acr build --registry <container-registry-name> --image trafficcontrolservice:assignment08 .
    ```

1.  Navigate to the `Resources/FineCollectionService` directory & use the Azure Container Registry task to build your image from source.

    ```shell
    az acr build --registry <container-registry-name> --image trafficcontrolservice:assignment08 .
    ```

### Step 4: Deploy container images to Azure Kubernetes Service

Now that your container images have been uploaded to the Azure Container Registry, you can deploy these images to your Azure Container Apps service.

_IMPORTANT: The Azure Container Registry has the **admin** account enabled to make this demo easier to deploy (doesn't require the deployer to have Owner access to the subscription or resource group the Azure resources are deployed to). **This is not a best practice!** In a production deployment, use a managed identity or service principal to authenticate between the ACA service & the ACR. See the [documentation](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication?tabs=azure-cli) for more about the options and how to set up._

1.  Deploy your new services to Azure. Navigate to the `Resources/Infrastructure/bicep` directory and run the following:

    ```shell
    cd Resources/Infrastructure/bicep
    az deployment group create -g <resource-group-name> --template-file ./main.bicep --parameters ./env/main.parameters.json --parameters shouldDeployToContainerApps=true
    ```

1.  Verify your services are provisioned (it may take a little while for all the services to finish starting up).

    ```shell
    az containerapp revision list -g <resource-group-name> -n ca-traffic-control-service --output table
    az containerapp revision list -g <resource-group-name> -n ca-fine-collection-service --output table
    az containerapp revision list -g <resource-group-name> -n ca-vehicle-registration-service --output table
    ```

### Step 7: Run Simulation application

Run the Simulation service, which writes to your IoT Hub's MQTT queue. You will begin to see fines get emailed to you as appropriate.

Review the logs as needed.

```shell
az containerapp logs show -g <resource-group-name> -n ca-fine-collection-service
```

## Security note

To make this example as accessible as possible, SAS tokens and default ACA security settings are in place. In a production environment, a more secure option is to use managed identities for the various services to talk to each other in Azure (for instance, allowing Azure Kubernetes Service to pull from Azure Container Registry).
