Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

choco install --yes kubernetes-helm
choco install --yes azure-cli
choco install --yes kubernetes-cli
choco install --yes git.install
choco install --yes docker-desktop
choco install --yes nodejs.install
choco install --yes nvm
choco install --yes wsl2 --params "/Version:2 /Retry:true"

