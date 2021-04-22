# Name: ADDSDeployment
# Version: 1.0.0.0
# CreatedOn: 2019-08-12 11:46:51Z

Add-Type -IgnoreWarnings -TypeDefinition @'
namespace Microsoft.DirectoryServices.Deployment.Types
{
    public enum DomainMode : int
    {
        Win2008 = 3,
        Win2008R2 = 4,
        Win2012 = 5,
        Win2012R2 = 6,
        WinThreshold = 7,
        Default = -1,
    }

    public enum DomainType : int
    {
        ChildDomain = 0,
        TreeDomain = 1,
    }

    public enum ForestMode : int
    {
        Win2008 = 3,
        Win2008R2 = 4,
        Win2012 = 5,
        Win2012R2 = 6,
        WinThreshold = 7,
        Default = -1,
    }

}

'@

function Add-ADDSReadOnlyDomainControllerAccount {
    <#
    .SYNOPSIS
        Add-ADDSReadOnlyDomainControllerAccount -DomainControllerAccountName <string> -DomainName <string> -SiteName <string> [-SkipPreChecks] [-AllowPasswordReplicationAccountName <string[]>] [-Credential <pscredential>] [-DelegatedAdministratorAccountName <string>] [-DenyPasswordReplicationAccountName <string[]>] [-NoGlobalCatalog] [-InstallDns] [-ReplicationSourceDC <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSReadOnlyDomainControllerAccount', SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [switch]
        ${SkipPreChecks},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${DomainControllerAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string[]]
        ${AllowPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string]
        ${DelegatedAdministratorAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string[]]
        ${DenyPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string]
        ${ReplicationSourceDC},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Install-ADDSDomain {
    <#
    .SYNOPSIS
        Install-ADDSDomain -NewDomainName <string> -ParentDomainName <string> [-SkipPreChecks] [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-AllowDomainReinstall] [-CreateDnsDelegation] [-Credential <pscredential>] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-DomainMode <DomainMode>] [-DomainType <DomainType>] [-NoGlobalCatalog] [-InstallDns] [-LogPath <string>] [-NewDomainNetbiosName <string>] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SiteName <string>] [-SkipAutoConfigureDns] [-SysvolPath <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomain', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${SkipPreChecks},

        [Parameter(ParameterSetName='ADDSDomain', Mandatory=$true)]
        [string]
        ${NewDomainName},

        [Parameter(ParameterSetName='ADDSDomain', Mandatory=$true)]
        [string]
        ${ParentDomainName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${ADPrepCredential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${AllowDomainReinstall},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSDomain')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        ${DomainMode},

        [Parameter(ParameterSetName='ADDSDomain')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainType]
        ${DomainType},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${NewDomainNetbiosName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${ReplicationSourceDC},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${SysvolPath},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Install-ADDSDomainController {
    <#
    .SYNOPSIS
        Install-ADDSDomainController -DomainName <string> [-SkipPreChecks] [-SafeModeAdministratorPassword <securestring>] [-SiteName <string>] [-ADPrepCredential <pscredential>] [-AllowDomainControllerReinstall] [-ApplicationPartitionsToReplicate <string[]>] [-CreateDnsDelegation] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <string>] [-InstallDns] [-LogPath <string>] [-MoveInfrastructureOperationMasterRoleIfNecessary] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]

Install-ADDSDomainController -DomainName <string> -SiteName <string> [-SkipPreChecks] [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-AllowDomainControllerReinstall] [-AllowPasswordReplicationAccountName <string[]>] [-ApplicationPartitionsToReplicate <string[]>] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-DelegatedAdministratorAccountName <string>] [-DenyPasswordReplicationAccountName <string[]>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <string>] [-InstallDns] [-LogPath <string>] [-MoveInfrastructureOperationMasterRoleIfNecessary] [-ReadOnlyReplica] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]

Install-ADDSDomainController -DomainName <string> [-SkipPreChecks] [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-ApplicationPartitionsToReplicate <string[]>] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-NoDnsOnNetwork] [-InstallationMediaPath <string>] [-LogPath <string>] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-UseExistingAccount] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomainController', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${SkipPreChecks},

        [Parameter(ParameterSetName='ADDSDomainController', Mandatory=$true)]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly', Mandatory=$true)]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly', Mandatory=$true)]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [pscredential]
        ${ADPrepCredential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${AllowDomainControllerReinstall},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string[]]
        ${AllowPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string[]]
        ${ApplicationPartitionsToReplicate},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${CriticalReplicationOnly},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string]
        ${DelegatedAdministratorAccountName},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string[]]
        ${DenyPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${InstallationMediaPath},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${MoveInfrastructureOperationMasterRoleIfNecessary},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${ReadOnlyReplica},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${ReplicationSourceDC},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [securestring]
        ${SystemKey},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${SysvolPath},

        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${UseExistingAccount},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Install-ADDSForest {
    <#
    .SYNOPSIS
        Install-ADDSForest -DomainName <string> [-SkipPreChecks] [-SafeModeAdministratorPassword <securestring>] [-CreateDnsDelegation] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-DomainMode <DomainMode>] [-DomainNetbiosName <string>] [-ForestMode <ForestMode>] [-InstallDns] [-LogPath <string>] [-NoRebootOnCompletion] [-SkipAutoConfigureDns] [-SysvolPath <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSForest', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${SkipPreChecks},

        [Parameter(ParameterSetName='ADDSForest', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSForest')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSForest')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSForest')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        ${DomainMode},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${DomainNetbiosName},

        [Parameter(ParameterSetName='ADDSForest')]
        [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
        ${ForestMode},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${SysvolPath},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Test-ADDSDomainControllerInstallation {
    <#
    .SYNOPSIS
        Test-ADDSDomainControllerInstallation -DomainName <string> [-SafeModeAdministratorPassword <securestring>] [-SiteName <string>] [-ADPrepCredential <pscredential>] [-AllowDomainControllerReinstall] [-ApplicationPartitionsToReplicate <string[]>] [-CreateDnsDelegation] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <string>] [-InstallDns] [-LogPath <string>] [-MoveInfrastructureOperationMasterRoleIfNecessary] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-Force] [<CommonParameters>]

Test-ADDSDomainControllerInstallation -DomainName <string> -SiteName <string> [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-AllowDomainControllerReinstall] [-AllowPasswordReplicationAccountName <string[]>] [-ApplicationPartitionsToReplicate <string[]>] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-DelegatedAdministratorAccountName <string>] [-DenyPasswordReplicationAccountName <string[]>] [-NoDnsOnNetwork] [-NoGlobalCatalog] [-InstallationMediaPath <string>] [-InstallDns] [-LogPath <string>] [-MoveInfrastructureOperationMasterRoleIfNecessary] [-ReadOnlyReplica] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-Force] [<CommonParameters>]

Test-ADDSDomainControllerInstallation -DomainName <string> [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-ApplicationPartitionsToReplicate <string[]>] [-Credential <pscredential>] [-CriticalReplicationOnly] [-DatabasePath <string>] [-NoDnsOnNetwork] [-InstallationMediaPath <string>] [-LogPath <string>] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SkipAutoConfigureDns] [-SystemKey <securestring>] [-SysvolPath <string>] [-UseExistingAccount] [-Force] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomainController')]
    param (
        [Parameter(ParameterSetName='ADDSDomainController', Mandatory=$true)]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly', Mandatory=$true)]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly', Mandatory=$true)]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [pscredential]
        ${ADPrepCredential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${AllowDomainControllerReinstall},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string[]]
        ${AllowPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string[]]
        ${ApplicationPartitionsToReplicate},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${CriticalReplicationOnly},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string]
        ${DelegatedAdministratorAccountName},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [string[]]
        ${DenyPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${InstallationMediaPath},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${MoveInfrastructureOperationMasterRoleIfNecessary},

        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [switch]
        ${ReadOnlyReplica},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${ReplicationSourceDC},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [securestring]
        ${SystemKey},

        [Parameter(ParameterSetName='ADDSDomainController')]
        [Parameter(ParameterSetName='ADDSDomainControllerReadOnly')]
        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [string]
        ${SysvolPath},

        [Parameter(ParameterSetName='ADDSDomainControllerUseExistingAccount')]
        [switch]
        ${UseExistingAccount},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Test-ADDSDomainControllerUninstallation {
    <#
    .SYNOPSIS
        Test-ADDSDomainControllerUninstallation [-LocalAdministratorPassword <securestring>] [-Credential <pscredential>] [-DemoteOperationMasterRole] [-DnsDelegationRemovalCredential <pscredential>] [-IgnoreLastDCInDomainMismatch] [-IgnoreLastDnsServerForZone] [-LastDomainControllerInDomain] [-NoRebootOnCompletion] [-RemoveApplicationPartitions] [-RemoveDnsDelegation] [-RetainDCMetadata] [-Force] [<CommonParameters>]

Test-ADDSDomainControllerUninstallation -ForceRemoval [-LocalAdministratorPassword <securestring>] [-Credential <pscredential>] [-DemoteOperationMasterRole] [-NoRebootOnCompletion] [-Force] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomainControllerUninstall')]
    param (
        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [securestring]
        ${LocalAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [switch]
        ${DemoteOperationMasterRole},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [pscredential]
        ${DnsDelegationRemovalCredential},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval', Mandatory=$true)]
        [switch]
        ${ForceRemoval},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${IgnoreLastDCInDomainMismatch},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${IgnoreLastDnsServerForZone},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${LastDomainControllerInDomain},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RemoveApplicationPartitions},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RemoveDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RetainDCMetadata},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Test-ADDSDomainInstallation {
    <#
    .SYNOPSIS
        Test-ADDSDomainInstallation -NewDomainName <string> -ParentDomainName <string> [-SafeModeAdministratorPassword <securestring>] [-ADPrepCredential <pscredential>] [-AllowDomainReinstall] [-CreateDnsDelegation] [-Credential <pscredential>] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-DomainMode <DomainMode>] [-DomainType <DomainType>] [-NoGlobalCatalog] [-InstallDns] [-LogPath <string>] [-NewDomainNetbiosName <string>] [-NoRebootOnCompletion] [-ReplicationSourceDC <string>] [-SiteName <string>] [-SkipAutoConfigureDns] [-SysvolPath <string>] [-Force] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomain')]
    param (
        [Parameter(ParameterSetName='ADDSDomain', Mandatory=$true)]
        [string]
        ${NewDomainName},

        [Parameter(ParameterSetName='ADDSDomain', Mandatory=$true)]
        [string]
        ${ParentDomainName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${ADPrepCredential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${AllowDomainReinstall},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSDomain')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSDomain')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        ${DomainMode},

        [Parameter(ParameterSetName='ADDSDomain')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainType]
        ${DomainType},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${NewDomainNetbiosName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${ReplicationSourceDC},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSDomain')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSDomain')]
        [string]
        ${SysvolPath},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Test-ADDSForestInstallation {
    <#
    .SYNOPSIS
        Test-ADDSForestInstallation -DomainName <string> [-SafeModeAdministratorPassword <securestring>] [-CreateDnsDelegation] [-DatabasePath <string>] [-DnsDelegationCredential <pscredential>] [-NoDnsOnNetwork] [-DomainMode <DomainMode>] [-DomainNetbiosName <string>] [-ForestMode <ForestMode>] [-InstallDns] [-LogPath <string>] [-NoRebootOnCompletion] [-SkipAutoConfigureDns] [-SysvolPath <string>] [-Force] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSForest')]
    param (
        [Parameter(ParameterSetName='ADDSForest', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSForest')]
        [securestring]
        ${SafeModeAdministratorPassword},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${CreateDnsDelegation},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${DatabasePath},

        [Parameter(ParameterSetName='ADDSForest')]
        [pscredential]
        ${DnsDelegationCredential},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${NoDnsOnNetwork},

        [Parameter(ParameterSetName='ADDSForest')]
        [Microsoft.DirectoryServices.Deployment.Types.DomainMode]
        ${DomainMode},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${DomainNetbiosName},

        [Parameter(ParameterSetName='ADDSForest')]
        [Microsoft.DirectoryServices.Deployment.Types.ForestMode]
        ${ForestMode},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${LogPath},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSForest')]
        [switch]
        ${SkipAutoConfigureDns},

        [Parameter(ParameterSetName='ADDSForest')]
        [string]
        ${SysvolPath},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Test-ADDSReadOnlyDomainControllerAccountCreation {
    <#
    .SYNOPSIS
        Test-ADDSReadOnlyDomainControllerAccountCreation -DomainControllerAccountName <string> -DomainName <string> -SiteName <string> [-AllowPasswordReplicationAccountName <string[]>] [-Credential <pscredential>] [-DelegatedAdministratorAccountName <string>] [-DenyPasswordReplicationAccountName <string[]>] [-NoGlobalCatalog] [-InstallDns] [-ReplicationSourceDC <string>] [-Force] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSReadOnlyDomainControllerAccount')]
    param (
        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${DomainControllerAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${DomainName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount', Mandatory=$true)]
        [string]
        ${SiteName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string[]]
        ${AllowPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string]
        ${DelegatedAdministratorAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string[]]
        ${DenyPasswordReplicationAccountName},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [switch]
        ${NoGlobalCatalog},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [switch]
        ${InstallDns},

        [Parameter(ParameterSetName='ADDSReadOnlyDomainControllerAccount')]
        [string]
        ${ReplicationSourceDC},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

function Uninstall-ADDSDomainController {
    <#
    .SYNOPSIS
        Uninstall-ADDSDomainController [-SkipPreChecks] [-LocalAdministratorPassword <securestring>] [-Credential <pscredential>] [-DemoteOperationMasterRole] [-DnsDelegationRemovalCredential <pscredential>] [-IgnoreLastDCInDomainMismatch] [-IgnoreLastDnsServerForZone] [-LastDomainControllerInDomain] [-NoRebootOnCompletion] [-RemoveApplicationPartitions] [-RemoveDnsDelegation] [-RetainDCMetadata] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]

Uninstall-ADDSDomainController -ForceRemoval [-SkipPreChecks] [-LocalAdministratorPassword <securestring>] [-Credential <pscredential>] [-DemoteOperationMasterRole] [-NoRebootOnCompletion] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
    #>

    [CmdletBinding(DefaultParameterSetName='ADDSDomainControllerUninstall', SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [switch]
        ${SkipPreChecks},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [securestring]
        ${LocalAdministratorPassword},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [pscredential]
        ${Credential},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [switch]
        ${DemoteOperationMasterRole},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [pscredential]
        ${DnsDelegationRemovalCredential},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval', Mandatory=$true)]
        [switch]
        ${ForceRemoval},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${IgnoreLastDCInDomainMismatch},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${IgnoreLastDnsServerForZone},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${LastDomainControllerInDomain},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [Parameter(ParameterSetName='ADDSDomainControllerUninstallForceRemoval')]
        [switch]
        ${NoRebootOnCompletion},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RemoveApplicationPartitions},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RemoveDnsDelegation},

        [Parameter(ParameterSetName='ADDSDomainControllerUninstall')]
        [switch]
        ${RetainDCMetadata},

        [switch]
        ${Force}
    )
    end {
        throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
    }
}

