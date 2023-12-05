
# This script should be run on the Visual Studio VM anytime the eShopOnWeb source code is updated on the VM.
# It will build the solution and publish a copy of the output artifacts to a file share.

# The VM instances of the VM scale set are configured to pull the artifacts from this file share when they are created.
# After running this script, you will need to delete the VM instances of the VMSS. 
# New VM instances will be created by the VMSS and pick up the updated application code.

# Configure eShoponWeb application
# Run dotnet restore with arguments
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-main\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetrestoreoutput.txt" -Passthru)
$proc | Wait-Process

#This is the addition for dotnet tool restore command to be placed after Run dotnet restore with arguments and before Configure CatalogDb
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('tool','restore') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnettoolrestoreoutput.txt" -Passthru)
$proc | Wait-Process

#Configure CatalogDb

$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','catalogcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefcatoutput.txt" -Passthru)
$proc | Wait-Process

#Configure Identity Db
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('ef','database','update','-c','appidentitydbcontext','-p','../Infrastructure/Infrastructure.csproj','-s','Web.csproj') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetefappoutput.txt" -Passthru)
$proc | Wait-Process

#Run dotnet build
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('build') -WorkingDirectory $eShopWebDestination -RedirectStandardOutput "c:\windows\temp\dotnetbuildoutput.txt" -Passthru)
$proc | Wait-Process

# Run dotnet publish to to publish files to our share created above
$eShopWebDestination = "C:\eshoponweb\eShopOnWeb-main\src\Web"
$proc = (Start-Process -FilePath 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList ('publish','--output','C:\eShopPub\wwwroot\') -WorkingDirectory $eShopWebDestination -Passthru -RedirectStandardOutput "c:\windows\temp\dotnetpuboutput.txt")
$proc | Wait-Process
