Connect-PowerBIServiceAccount

$group = "19742052-c60e-4f83-8ec7-d7a060045293"
$dataflows = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups/${group}/dataflows" -Method GET

#9f1961e7-f159-40c4-a6d9-b872a7df54af/transactions/ -Method GET
#Invoke-PowerBIRestMethod -Url https://api.powerbi.com/v1.0/myorg/groups/19742052-c60e-4f83-8ec7-d7a060045293/dataflows/transactions/a184d57d-628a-4d07-bc1b-21dc2a884084$5386940/cancel -Method POST
#POST https://api.powerbi.com/v1.0/myorg/groups/{groupId}/dataflows/transactions/{transactionId}/cancel


$dfs = ConvertFrom-Json $dataflows
foreach ($dataflow in $dfs.value) {
    $dataflowId = $dataflow.objectId
    $txs = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups/${group}/dataflows/${dataflowId}/transactions" -Method GET
    $txs = ConvertFrom-Json $txs


    foreach ($tx in $txs.value) {
        if($tx.status -eq "InProgress") {
            $id = $tx.id
            Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups/${group}/dataflows/transactions/${id}/cancel" -Method POST
        }
    }
}

foreach ($dataflow in $dfs.value) {
    $dataflowId = $dataflow.objectId
    Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups/${group}/dataflows/${dataflowId}" -Method DELETE
}