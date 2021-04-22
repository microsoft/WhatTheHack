$Properties = @{
                Name      = New-xDscResourceProperty -Name Name -Type String -Attribute Key `
                                                     -Description 'Name of the secondary zone'
                DnsServer = New-xDscResourceProperty -Name MasterServerIPAddress -Type String[] -Attribute Required `
                                                     -Description 'IP address of secondary DNS servers'
                Ensure    = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet 'Present','Absent' `
                                                     -Description 'Should this resource be present or absent'
                
            }
New-xDscResource -Name MSFT_xDnsServerSecondaryZone -Property $Properties.Values -Path . -ModuleName xDnsServer -FriendlyName xDnsServerSecondaryZone -Force
