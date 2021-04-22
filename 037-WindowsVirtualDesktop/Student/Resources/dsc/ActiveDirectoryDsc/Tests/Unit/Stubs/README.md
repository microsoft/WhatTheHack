# Stubs

A stub function is function with just the skeleton of the original function
or cmdlet. Pester can use a stub function to have something to hook into
when a mock of a cmdlet or function is needed in a unit test. Stub functions
make it possible to run unit tests without having the actual module with
the cmdlet or function installed.

## How to

>**NOTE!** The stubs have been altered after that the modules have been
>generated. How they were altered is describe in the below procedure.

Install the module 'Indented.StubCommand' from PowerShell Gallery.

```powershell
Install-Module Indented.StubCommand -Scope CurrentUser
```

Install the necessary features to get the modules to create stubs from.

```powershell
Add-WindowsFeature AD-Domain-Services
Add-WindowsFeature RSAT-AD-PowerShell
```

Create the stub modules in output folder 'c:\projects\stub' (can be any
folder).

```powershell
$destinationFolder = 'c:\projects\stubs\'

$functionBody = {
    throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
}

New-StubModule -FromModule 'ActiveDirectory' -Path $destinationFolder -FunctionBody $functionBody -ReplaceTypeDefinition @(
    @{
        ReplaceType = 'System\.Nullable`1\[Microsoft\.ActiveDirectory\.Management\.\w*\]'
        WithType = 'System.Object'
    },
    @{
        ReplaceType = 'Microsoft\.ActiveDirectory\.Management\.Commands\.\w*'
        WithType = 'System.Object'
    },
    @{
        ReplaceType = 'Microsoft\.ActiveDirectory\.Management\.\w*'
        WithType = 'System.Object'
    }
)

New-StubModule -FromModule 'ADDSDeployment' -Path $destinationFolder -FunctionBody $functionBody
```

Some types that is referenced by the code is not automatically create with
the cmdlet `New-StubModule`. Run the following, then the stub classes that
are outputted should be copied into the ActiveDirectory stub module that
was generated above, inside the namespace `Microsoft.ActiveDirectory.Management`.

```powershell
Import-Module ActiveDirectory
New-StubType -Type 'Microsoft.ActiveDirectory.Management.ADException' -ExcludeAddType
New-StubType -Type 'Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException' -ExcludeAddType
New-StubType -Type 'Microsoft.ActiveDirectory.Management.ADServerDownException' -ExcludeAddType
```

After the types are added, they need to make sure they inherit from `System.Exception`.
This must be done for each type created with `New-StubType`.

Example:

```csharp
public class ADIdentityNotFoundException : System.Exception
{
    ...
}
```

The stub class `Microsoft.ActiveDirectory.Management.ADDomainController`
can not be generated fully since all properties that are returned from
`Get-ADDomainController` are not shown when using the type directly, e.g.
`$a = New-Object -TypeName 'Microsoft.ActiveDirectory.Management.ADDomainController'`.
To workaround this these properties below must be added manually to the stub
class `ADDomainController` in the namespace `Microsoft.ActiveDirectory.Management`.

```csharp
public class ADDomainController
{
    ...

    // Property
    ...
    public bool IsGlobalCatalog;
    public bool IsReadOnly;
    public Microsoft.ActiveDirectory.Management.ADOperationMasterRole[] OperationMasterRoles;
}
```

The helper function `Get-MembersToAddAndRemove` in ADDomainController resource
depends on the member (principal) property `SamAccountName` is returned
by the method `ToString()` and that is not automatically generated.
Update the stub class `ADPrincipal` constructor and add the method like this.

```csharp
    public class ADPrincipal
    {
        // Constructor
        ...
        public ADPrincipal(System.String identity) { SamAccountName = identity; }

        ...

        // Method
        public override string ToString()
        {
            return this.SamAccountName;
        }
    }
```
