$Public = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" )

@($Public + $Private) | ForEach-Object {
    Try {
        . $_.FullName
    } Catch {
        Write-Error -Message "Failed to import function $($_.FullName): $_"
    }
}
