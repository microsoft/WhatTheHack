$Properties = @{
                Name      = New-xDscResourceProperty -Name Name -Type String -Attribute Key `
                                                     -Description 'Name of the secondary zone'
                Type = New-xDscResourceProperty -Name Type -Type String -Attribute Required -ValidateSet 'Any', 'Named', 'Specific' `
                                                     -Description 'Type of transfer allowed'
                SecondaryServer = New-xDscResourceProperty -Name SecondaryServerIPAddress -Type String[] -Attribute Write `
                                                     -Description 'IP address of DNS servers where zone information can be sent'
                Ensure    = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet 'Present','Absent' `
                                                     -Description 'Should this resource be present or absent'
                
            }
New-xDscResource -Name MSFT_xDnsServerZoneTransfer -Property $Properties.Values -Path . -ModuleName xDnsServer -FriendlyName xDnsServerZoneTransfer -Force
