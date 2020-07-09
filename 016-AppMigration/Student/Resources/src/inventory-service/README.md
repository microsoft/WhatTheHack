# Inventory Service

This project needs an instance of SQL Server, SQL Database, or PostgreSQL.

## Local dev

Create a user secret in InventoryService.Api project and run the app:

```
dotnet user-secrets set 'ConnectionStrings:InventoryContext' '<sqldb-connection-string>'
dotnet run
```

## Running in the cloud or in containers

Set an environment variable named `ConnectionStrings__InventoryContext`.

(Or use Azure Key Vault (below))


#### Example Connection String

```
Server=tailwind32671.postgres.database.azure.com;Database=Tailwind;Port=5432;User Id=admin_1136@tailwind32671;Password={Your Password};SslMode=Require;"
```

- REST API docs can be accessed using Swagger UI: `/swagger`
- Get real-time inventory updates, see SignalR test page: `/www`

Optional: Use Azure SignalR Service by adding another secret (local dev only, use environment variable everywhere else):

```
dotnet user-secrets set 'SignalRServiceConnectionString' '<azure-signalr-connection-string>'
```

## Key Vault

Set 2 environment variables:
* `AzureServicesAuthConnectionString` = `RunAs=App;AppId={AppId};TenantId={TenantId};AppKey={ClientSecret}`
* `KeyVaultEndpoint` = `https://{keyvaultname}.vault.azure.net/`


## Build the Docker Image

Building the Docker image is pretty easy. If you have [Docker](https://docker.com) installed, run this:

```console
docker build -t inventory-service .
```

You can swap out `inventory-service` for your own image name.

### Building with [ACR Builds](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task)

Or you can use [Azure Container Registry Builds](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task) to do it:

```console
az acr build -r my-registry -t inventory-service .
```

A few notes about this:

- This will cost you money
- The `-r` argument has to be a registry you've created already
- Like the previous command, you can swap out `inventory-service` for your own image name
