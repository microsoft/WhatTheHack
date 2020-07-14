FROM microsoft/dotnet:2.2-sdk

COPY . /home/

RUN cd /home/ \
    && dotnet clean \
    && dotnet publish -c Release \
    && cd /home/InventoryService.Api/bin/Release/netcoreapp2.1/publish/

WORKDIR /home/InventoryService.Api/bin/Release/netcoreapp2.1/publish/

ENTRYPOINT dotnet InventoryService.Api.dll --urls http://*:$PORT
