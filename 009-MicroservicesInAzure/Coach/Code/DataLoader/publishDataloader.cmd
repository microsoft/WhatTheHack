dotnet clean DataLoader.csproj
rmdir /s /q publish
dotnet publish DataLoader.csproj -c Release -o publish
docker build -t arkhitekton-dataloader .
docker tag arkhitekton-dataloader andywahr/arkhitekton-dataloader:latest
docker push andywahr/arkhitekton-dataloader:latest