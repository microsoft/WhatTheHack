Write-Host "FastHack Dedicated SQL Pool - Performance best practices"
Write-Host "Challenge 2 Excercise 1 - Simulate activities"

$SubscriptionId = Read-Host -Prompt "Enter your SubscriptionId"
$DedicatedPoolEndPoint = Read-Host -Prompt "Enter Server Instance"
$DedicatedPoolName = Read-Host -Prompt "Enter Dedicated SQL Pool name"

Connect-AzAccount -SubscriptionId $SubscriptionId
$token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token

$SQLcommand = "DECLARE @i SMALLINT
SELECT @i = (SELECT COUNT(*) FROM Sales.DimCurrency)

BEGIN TRANSACTION

UPDATE Sales.FactInternetSales SET CurrencyKey = ABS(CHECKSUM(NEWID())) % @i + 1
WHERE OrderDateKey >=20110101 AND OrderDateKey <= 20110630
OPTION (LABEL = 'Transaction 1 - OrderDateKey >=20110101 AND OrderDateKey <= 20110630')"

Invoke-SqlCmd -ServerInstance $DedicatedPoolEndPoint -Database $DedicatedPoolName -AccessToken $token -Query $SQLcommand 

Read-Host -Prompt "Run the proposed T-SQL script. 
Do not close this session until you complete the excercise. 
Press any button to complete"