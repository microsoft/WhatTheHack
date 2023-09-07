FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["RockPaperScissorsBoom.Server/RockPaperScissorsBoom.Server.csproj", "RockPaperScissorsBoom.Server/"]
RUN dotnet restore "RockPaperScissorsBoom.Server/RockPaperScissorsBoom.Server.csproj"
COPY . .
WORKDIR "/src/RockPaperScissorsBoom.Server"
RUN dotnet build "RockPaperScissorsBoom.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RockPaperScissorsBoom.Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RockPaperScissorsBoom.Server.dll"]