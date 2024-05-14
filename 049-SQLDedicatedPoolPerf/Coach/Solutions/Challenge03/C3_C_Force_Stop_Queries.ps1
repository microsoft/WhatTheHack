$Kill = Read-Host -Prompt "Are you sure you want to kill all powershell sessions on this machine ? [Y] Yes, [N] No"

if($Kill -eq "Y")
{  
	Get-Process -Name powershell | Stop-Process
	write-host "Done."
}
else
{  
	write-host "Aborted."
}
