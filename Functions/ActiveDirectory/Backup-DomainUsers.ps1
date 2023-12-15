FUNCTION Backup-DomainUsers {
    <#
        .DESCRIPTION
        Perform a backup of domain user account.
        .FUNCTIONALITY
        Developed to export a list of users for insert into new domain.
        .PARAMETER Path
        Location to export the CSV list.
        .PARAMETER OU
        OU path to users.  Optional
        .PARAMETER Exclude
        Array of user SamAccountNames to exclude from the list. Default array is @('Administrator', 'Guest', 'krbtgt', 'Hyper V').
        .EXAMPLE
        PS> Backup-DomainUsers -Path 'C:\Domain'
        .EXAMPLE
        PS> Backup-DomainUsers -Path 'C:\Domain' -OU 'OU=Users,OU=secure.lan,DC=secure,DC=lan'
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ IF ( -Not ($_ | Test-Path) ) { THROW "Path $_ is not valid" } RETURN $true })]
        [System.IO.FileInfo]$Path = [Environment]::GetFolderPath('Desktop'),
        [Parameter(Mandatory = $false)]
        [string]$OU,
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = @('Administrator', 'Guest', 'krbtgt', 'Hyper V')
    )
    BEGIN {
        $ReturnData = @()
        $Today = Get-Date -Format 'yyyyMMdd'
        $Domain = (Get-ADDomain).Forest
    }
    PROCESS {
        # Get listing of all users
        $Params = @{ 'Filter' = '*'; }
        IF ($OU) { $Params.Add('SearchBase', $OU) }
        IF ($Exclude) {
            $UserList = Get-ADUser @Params | Where-Object { $_.SamAccountName -notin $Exclude }
        }
        ELSE {
            $UserList = Get-ADUser @Params
        }

        # Process each user individually
        $ReturnData = $UserList | ForEach-Object {
            IF ($_.Enabled -eq $true) {
                $ThisUser = Get-ADUser -Identity $_.SamAccountName -Properties *
                $ThisData = [PSCustomObject] @{
                    FirstName      = $ThisUser.GivenName
                    LastName       = $ThisUser.SurName
                    SamAccountName = $ThisUser.SamAccountName
                    Description    = $ThisUser.Description
                    Department     = $ThisUser.Department
                    Title          = $ThisUser.Title
                    Email          = $ThisUser.EmailAddress
                }
                $ThisData
            }
        }
    }
    END {
        $OutPath = Join-Path -Path $Path -ChildPath "Users-$Domain-$Today.cav"
        $ReturnData | Export-Csv -Path $OutPath -NoTypeInformation
    }
}