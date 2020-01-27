FROM microsoft/dotnet:2.2-sdk as builder
COPY . /home/
RUN cd /home/ \
    && dotnet clean \
    && dotnet publish -c Release \
    && cd /home/InventoryService.Api/bin/Release/netcoreapp2.1/publish/

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
WORKDIR /home/publish/
COPY --from=builder /home/InventoryService.Api/bin/Release/netcoreapp2.1/publish/ .
ENTRYPOINT dotnet InventoryService.Api.dll --urls http://*:$PORT
