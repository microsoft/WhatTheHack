#! /usr/bin/pwsh

Param(
    [parameter(Mandatory=$false)][string[]]$pathParts
)

if ($pathParts.Length -le 0) {
    Write-Host "You need to call with at least one path part" -ForegroundColor Red
    exit 1
}

if ($pathParts.Length -eq 1) {
    Write-Output $pathParts[0]
}
else {
    $childPath=$(./Join-Path-Recursively.ps1 -pathParts $pathParts[1..($pathParts.Length-1)])
    Join-Path -Path $pathParts[0] -ChildPath $childPath | Write-Output
}