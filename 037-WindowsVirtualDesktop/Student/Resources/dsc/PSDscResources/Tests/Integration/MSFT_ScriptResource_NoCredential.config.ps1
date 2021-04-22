param
(
    [Parameter(Mandatory = $true)]
    [System.String]
    $ConfigurationName
)

Configuration $ConfigurationName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FileContent
    )

    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Script ScriptExample
        {
            SetScript = {
                $streamWriter = New-Object -TypeName 'System.IO.StreamWriter' -ArgumentList @( $using:FilePath )
                $streamWriter.WriteLine($using:FileContent)
                $streamWriter.Close()
            }
            TestScript = {
                if (Test-Path -Path $using:FilePath)
                {
                    $fileContent = Get-Content -Path $using:filePath -Raw
                    return $fileContent -eq $using:FileContent
                }
                else
                {
                    return $false
                }
            }
            GetScript = {
                $fileContent = $null

                if (Test-Path -Path $using:FilePath)
                {
                    $fileContent = Get-Content -Path $using:filePath -Raw
                }

                return @{
                    Result = Get-Content -Path $fileContent
                }
            }
        }
    }
}
