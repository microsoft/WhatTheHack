FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["RockPaperScissorsBoom.ExampleBot/RockPaperScissorsBoom.ExampleBot.csproj", "RockPaperScissorsBoom.ExampleBot/"]
RUN dotnet restore "RockPaperScissorsBoom.ExampleBot/RockPaperScissorsBoom.ExampleBot.csproj"
COPY . .
WORKDIR "/src/RockPaperScissorsBoom.ExampleBot"
RUN dotnet build "RockPaperScissorsBoom.ExampleBot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RockPaperScissorsBoom.ExampleBot.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RockPaperScissorsBoom.ExampleBot.dll"]