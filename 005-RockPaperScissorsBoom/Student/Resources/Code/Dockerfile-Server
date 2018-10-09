FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY RockPaperScissorsBoom.Server/RockPaperScissorsBoom.Server.csproj RockPaperScissorsBoom.Server/
RUN dotnet restore RockPaperScissorsBoom.Server/RockPaperScissorsBoom.Server.csproj
COPY RockPaperScissorsBoom.Server/ RockPaperScissorsBoom.Server/
COPY RockPaperScissor.Core/ RockPaperScissor.Core/
WORKDIR /src/RockPaperScissorsBoom.Server
RUN dotnet build RockPaperScissorsBoom.Server.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish RockPaperScissorsBoom.Server.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RockPaperScissorsBoom.Server.dll"]