/*-----------------------------------------------------------------------------8
|                                                                              |
| Version Operators:                                                           |
|   = (or no operator): exact version equality                                 |
|   !=                : version not equal                                      |
|   >, >=, <, <=      : version comparison, where "greater than" is a larger   |
|                       version number                                         |
|   ~>                : pessimistic constraint operator, constraining both the |
|                       oldest and newest version allowed. For example, ~> 0.9 |
|                       is equivalent to >= 0.9, < 1.0, and ~> 0.8.4, is       |
|                       equivalent to >= 0.8.4, < 0.9                          |
|                                                                              |
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
|                                                                              |
|                              TERRAFORM VERSION                               |
|                                                                              |
+--------------------------------------4--------------------------------------*/
terraform                               { required_version = ">= 0.12"  }


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                  PROVIDERS                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/
provider azurerm                        {
                                          version = "~> 2.0" 
                                          features {}
                                        }
provider random                         { version = "~> 2.0" }
