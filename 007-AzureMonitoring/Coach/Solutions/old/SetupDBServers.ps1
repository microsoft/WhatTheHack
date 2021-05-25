#Create inbound Windows Firewall rule for SQL Server on TCP port 1433
New-NetFirewallRule -DisplayName "Allow SQL Connections on 1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow

#Switch SQL Authentication to mixed mode
Set-SqlAuthenticationMode -Credential $Credential -Mode Mixed -SqlCredential $sqlCredential -ForceServiceRestart -AcceptSelfSignedCertificate

#Create SQL Server user called sqladmin and grant SA rights

