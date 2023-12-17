FUNCTION Update-GraphToken {
    #TODO Needs to be tested
    <#
        .DESCRIPTION
        Modifies the MS Graph token with additional permissions.
        .FUNCTIONALITY
        Developed as a quick method to update MS Graph permissions as required.
        .PARAMETER Permission
        Array of the requested Microsoft Graph permissions.
        .EXAMPLE
        PS> Update-GraphToken -Permission @('User.Read.All')
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Permission
    )

    BEGIN {
        # Pull current security token
        $CurrentToken = Get-MgContext -ErrorAction SilentlyContinue
    }
    PROCESS {
        TRY{
            # Check if requested permissions are already set
            IF ($CurrentToken.Scopes -notcontains $Permission) {
                Connect-MgGraph -Scopes $Permission -NoWelcome -ErrorAction SilentlyContinue
            }
            ELSE {
                # Token already contains the requested permissions
                RETURN $true
            }
        }
        CATCH{
            Write-Error $Error[0]
        }
    }

    END {
        # Validate permission is now within token
        IF ((Get-MgContext -ErrorAction SilentlyContinue).Scopes -contains $Permission) {
            RETURN $true
        }
        ELSE {
            RETURN $false
        }
    }
}