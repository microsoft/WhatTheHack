FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine3.7 AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk-alpine3.7 AS build
WORKDIR /src
COPY ["./DataLoader/DataLoader.csproj", "./DataLoader/"]
RUN dotnet restore "./DataLoader/DataLoader.csproj"
COPY . .
WORKDIR "/src/DataLoader"
RUN dotnet build "DataLoader.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DataLoader.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DataLoader.dll"]