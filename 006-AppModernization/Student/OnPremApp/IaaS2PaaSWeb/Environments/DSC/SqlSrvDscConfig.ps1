Configuration Main
{
Param ( [string] $nodeName )

Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xSqlServer

Node $nodeName
  {
	  xSqlServerFirewall($nodeName)
        {
            SourcePath = "C:\SQLServerFull"
            InstanceName = "MSSQLSERVER"
            Features = "SQLENGINE"
        }
  }
}