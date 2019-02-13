FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY RockPaperScissorsBoom.ExampleBot/RockPaperScissorsBoom.ExampleBot.csproj RockPaperScissorsBoom.ExampleBot/
RUN dotnet restore RockPaperScissorsBoom.ExampleBot/RockPaperScissorsBoom.ExampleBot.csproj
COPY RockPaperScissorsBoom.ExampleBot/ RockPaperScissorsBoom.ExampleBot/
COPY RockPaperScissor.Core/ RockPaperScissor.Core/
WORKDIR /src/RockPaperScissorsBoom.ExampleBot
RUN dotnet build RockPaperScissorsBoom.ExampleBot.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish RockPaperScissorsBoom.ExampleBot.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RockPaperScissorsBoom.ExampleBot.dll"]