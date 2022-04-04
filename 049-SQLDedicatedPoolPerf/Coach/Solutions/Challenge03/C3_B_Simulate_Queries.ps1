Write-Host "FastHack Dedicated SQL Pool - Performance best practices"
Write-Host "Challenge 2 Excercise 2 - Simulate activities"

$SubscriptionId = Read-Host -Prompt "Enter your SubscriptionId"
$DedicatedPoolEndPoint = Read-Host -Prompt "Enter Server Instance"
$DedicatedPoolName = Read-Host -Prompt "Enter Dedicated SQL Pool name"

#create a workflow to run multiple sql in parallel
WorkFlow Run-PSQL #PSQL means Parallel SQL
{
    param(
        [Parameter(Mandatory=$true)]
        [string]$SubscriptionId,

        [Parameter(Mandatory=$true)]
        [string]$ServerInstance,

        [Parameter(Mandatory=$false)]
        [string]$Database,
        
        [Parameter(Mandatory=$true)]
        [string[]]$Query #a string array to hold t-sqls
    )

	Connect-AzAccount -SubscriptionId $SubscriptionId
	$token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token
	$i = 0

    foreach -parallel ($q in $query) 
    { 
		{ Session starting }
		invoke-sqlcmd -ServerInstance $ServerInstance -Database $Database -Query $q -AccessToken $token 
	}
	
} #Run-PSQL

$SQLcommand = "SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactInternetSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
UNION ALL
SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Sales.FactResellerSales Fis
	INNER JOIN Sales.FactInternetSalesReason Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Sales.DimSalesReason Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName"


#prepare a bunch of sql commands in a string arrary
[string[]]$SQLcommands = $SQLcommand, `
$SQLcommand, `
$SQLcommand, `
$SQLcommand;

Run-PSQL -SubscriptionId $SubscriptionId -Server $DedicatedPoolEndPoint -database $DedicatedPoolName -query $SQLcommands; 


