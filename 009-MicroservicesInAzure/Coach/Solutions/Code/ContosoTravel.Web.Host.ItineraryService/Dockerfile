FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine3.7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk-alpine3.7 AS build
WORKDIR /src
COPY ["./ContosoTravel.Web.Host.ItineraryService/Host.ItineraryService.csproj", "./ContosoTravel.Web.Host.ItineraryService/"]
RUN dotnet restore "./ContosoTravel.Web.Host.ItineraryService/Host.ItineraryService.csproj"
COPY . .
WORKDIR "/src/ContosoTravel.Web.Host.ItineraryService"
RUN dotnet build "Host.ItineraryService.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Host.ItineraryService.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ContosoTravel.Web.Host.ItineraryService.dll"]