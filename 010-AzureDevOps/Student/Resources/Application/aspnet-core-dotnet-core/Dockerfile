FROM microsoft/aspnetcore-build:1.1
WORKDIR /app

# Copy the published web app
COPY /aspnet-core-dotnet-core/ /app

# Run command
ENTRYPOINT ["dotnet", "aspnet-core-dotnet-core.dll"]
