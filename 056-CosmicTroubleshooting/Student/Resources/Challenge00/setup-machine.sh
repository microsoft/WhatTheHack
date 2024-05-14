#!/bin/bash

echoerr() { printf "\033[0;31m%s\n\033[0m" "$*" >&2; }
echosuccess() { printf "\033[0;32m%s\n\033[0m" "$*" >&2; }

# Install the az (with bicep)
echo "Installing tools"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash


#4.5. Install the Azure CLI packages, jq, .NET, zip
if [[ "$OSTYPE" =~ ^linux ]]; then
  sudo apt -qy install jq dotnet6 zip
else
  sudo apt -qy install dotnet6 zip
fi

if [[ "$OSTYPE" =~ ^darwin ]]; then
  brew help
  if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    brew update
  fi
  brew install jq
fi

# check installed tooling
echo "Testing tools:";
az version
if [ $? == 0 ]; then
  echosuccess "[.] az cli tool...OK";
else
  echoerr "Error with 'az cli' tool!";
  exit 1;
fi


az bicep version
if [ $? == 0 ]; then
  echosuccess "[.] bicep support...OK";
else
  echo "Installing bicep"
  az bicep install
  exit 1;
fi


dotnet --version
if [ $? == 0 ]; then
  echosuccess "[.] dotnet support...OK";
else
  echoerr "Error with dotnet!";
  exit 1;
fi

jq --version
if [ $? == 0 ]; then
  echosuccess "[.] jq tool...OK";
else
  echoerr "Error with 'jq' tool!";
  exit 1;
fi

echo "Asking user to log in...";
# ask user for login
az login
if [ $? == 0 ]; then
  echosuccess "
  Your machine should be ready! Now proceed with ./deploy.sh script
  
  ";
else
  echoerr "Login into Azure failed!";
  exit 1;
fi
