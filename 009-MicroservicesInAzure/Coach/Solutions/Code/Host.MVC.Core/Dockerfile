FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine3.7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk-alpine3.7 AS build
WORKDIR /src
COPY ["./Host.MVC.Core/Host.MVC.Core.csproj", "./Host.MVC.Core/"]
RUN dotnet restore "./Host.MVC.Core/Host.MVC.Core.csproj"
COPY . .
WORKDIR "/src/Host.MVC.Core"
RUN dotnet build "Host.MVC.Core.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Host.MVC.Core.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT false
RUN apk add --no-cache icu-libs

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENTRYPOINT ["dotnet", "ContosoTravel.Web.Host.MVC.Core.dll"]