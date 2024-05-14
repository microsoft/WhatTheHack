Write-Host "FastHack Dedicated SQL Pool - Performance best practices"
Write-Host "Challenge 3 Excercise 1 - Simulate activities"

$SubscriptionId = Read-Host -Prompt "Enter your SubscriptionId"
$DedicatedPoolEndPoint = Read-Host -Prompt "Enter Server Instance"
$DedicatedPoolName = Read-Host -Prompt "Enter Dedicated SQL Pool name"

Connect-AzAccount -SubscriptionId $SubscriptionId
$token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token

$query = "DECLARE @i SMALLINT
SELECT @i = (SELECT COUNT(*) FROM Sales.DimCurrency)

BEGIN TRANSACTION

UPDATE Sales.FactInternetSales SET CurrencyKey = ABS(CHECKSUM(NEWID())) % @i + 1
WHERE OrderDateKey >=20110101 AND OrderDateKey <= 20110630
OPTION (LABEL = 'Transaction 1 - OrderDateKey >=20110101 AND OrderDateKey <= 20110630')"

$connectionString = "Server=$DedicatedPoolEndPoint;Initial Catalog=$DedicatedPoolName;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Pooling=false"

$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString) 

# Set AAD generated token to SQL connection token 
$connection.AccessToken = $token 

# Opens connection to Azure SQL Database and executes a query 
$connection.Open() 

$command = New-Object -Type System.Data.SqlClient.SqlCommand($query, $connection) 
$command.ExecuteNonQuery() 
#$connection.Close() 

# Invoke-SqlCmd -ServerInstance $DedicatedPoolEndPoint -Database $DedicatedPoolName -AccessToken $token -Query $SQLcommand -ApplicationName "WTH - Dedicated SQL Pool - Challenge3 - Ex.1"

Read-Host -Prompt "Run the proposed T-SQL script. 
Do not close this session until you complete the excercise. 
Press any button to complete"