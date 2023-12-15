FUNCTION Restore-DomainUsers {
    <#
        .DESCRIPTION
        Creates a group of domain users based on CSV import.
        .FUNCTIONALITY
        Developed to assist in transferring domain users from one domain to another.
        .PARAMETER Path
        Location to of CSV document with users to import.
        .PARAMETER Password
        [SecureString] Password to use when creating users.
        .PARAMETER OU
        Domain OU path to create the new users in.
        .PARAMETER Disabled
        If set all accounts created will be set to disabled.
        .EXAMPLE
        PS> $Pass = Read-Host -AsSecureString -Prompt 'Enter Account Password'
        PS> Restore-DomainUsers -Path 'C:\Domain\Users-SECURE-20231214.csv' -Password $Pass
        .EXAMPLE
        PS> Restore-DomainUsers -Path 'C:\Domain\Users-SECURE-20231214.csv' -Password $Pass -OU 'OU=Users,OU=secure.lan,DC=secure,DC=lan'
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ IF ( -Not ($_ | Test-Path) ) { THROW "Path $_ is not valid" } RETURN $true })]
        [System.IO.FileInfo]$Path,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [string]$OU,
        [Parameter(Mandatory = $false)]
        [switch]$Disabled
    )
    BEGIN {

    }
    PROCESS {
        TRY {
            # Import user CSV file
            $UserData = Import-Csv -Path $Path

            # Process each user and build domain account
            FOREACH ($User in $UserData) {
                $Params = @{
                    Name            = $User.FirstName + ' ' + $User.LastName
                    GivenName       = $User.FirstName
                    SurName         = $User.SurName
                    SamAccountName  = $User.SamAccountName
                    AccountPassword = $Password
                }
                IF ($OU) { $Params.Add('Path', $OU) }
                IF ($Disabled.IsPresent) { $Params.Add('Enabled', $false) } ELSE { $Params.Add('Enabled', $true) }
                IF ($User.Description) { $Params.Add('Description', $User.Description) }
                IF ($User.Department) { $Params.Add('Department', $User.Department) }
                IF ($User.Title) { $Params.Add('Title', $User.Title) }
                IF ($User.Email) { $Params.Add('Email', $User.Email) }

                New-ADUser @Params
            }
        }
        CATCH {

        }
    }
    END {

    }
}