#!/bin/bash

set -e

dotnet user-secrets set 'ConnectionStrings:InventoryContext' '${SQLDB_CONNECTION_STRING}'
dotnet run
