ConvertFrom-StringData @'
    RoleNotFound                         = Please ensure that the PowerShell module for role {0} is installed
    InvalidCurrentValuesError            = Property 'CurrentValues' in Test-DscParameterState must be either a Hashtable, CimInstance or CimIntance[]. Type detected was '{0}'.
    InvalidDesiredValuesError            = Property 'DesiredValues' in Test-DscParameterState must be either a Hashtable or CimInstance. Type detected was '{0}'.
    InvalidValuesToCheckError            = If 'DesiredValues' is a CimInstance then property 'ValuesToCheck' must contain a value.
    TestDscParameterCompareMessage       = Comparing values in property '{0}'.
    MatchPsCredentialUsernameMessage     = MATCH: PSCredential username match. Current state is '{0}' and desired state is '{1}'.
    NoMatchPsCredentialUsernameMessage   = NOTMATCH: PSCredential username mismatch. Current state is '{0}' and desired state is '{1}'.
    NoMatchTypeMismatchMessage           = NOTMATCH: Type mismatch for property '{0}' Current state type is '{1}' and desired type is '{2}'.
    MatchValueMessage                    = MATCH: Value (type '{0}') for property '{1}' does match. Current state is '{2}' and desired state is '{3}'.
    NoMatchValueMessage                  = NOTMATCH: Value (type '{0}') for property '{1}' does not match. Current state is '{2}' and desired state is '{3}'.
    NoMatchValueDifferentCountMessage    = NOTMATCH: Value (type '{0}') for property '{1}' does have a different count. Current state count is '{2}' and desired state count is '{3}'.
    NoMatchElementTypeMismatchMessage    = NOTMATCH: Type mismatch for property '{0}' Current state type of element [{1}] is '{2}' and desired type is '{3}'.
    NoMatchElementValueMismatchMessage   = NOTMATCH: Value [{0}] (type '{1}') for property '{2}' does match. Current state is '{3}' and desired state is '{4}'.
    MatchElementValueMessage             = MATCH: Value [{0}] (type '{1}') for property '{2}' does match. Current state is '{3}' and desired state is '{4}'.
    TestDscParameterResultMessage        = Test-DscParameter result is '{0}'.
    StartingReverseCheck                 = Starting with a reverse check.
'@
