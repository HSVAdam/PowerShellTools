FUNCTION Update-MyModules {
    <#
        .DESCRIPTION
        Updated installed PowerShell modules from configured repository.
        .FUNCTIONALITY
        Developed to quickly install the updated version of modules.
        .PARAMETER Uninstall
        [switch] If defined will uninstall the older version if new install is successful.
        .EXAMPLE
        PS> Update-MyModules -Uninstall -Verbose
        .EXAMPLE
        PS> Update-MyModules -Verbose
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [switch]$Uninstall
    )
    BEGIN {
        $InstalledModules = Get-InstalledModule
    }
    PROCESS {
        FOREACH ($Module in $InstalledModules) {
            IF (($OnlineModule = Find-Module -Name $Module.Name -ErrorAction SilentlyContinue).Version -gt $Module.Version) {
                Install-Module -Name $($Module.Name) -RequiredVersion $($OnlineModule.Version) -Force
                IF (Get-Module -ListAvailable | Where-Object { $_.Name -eq $($Module.Name) -and $_.Version -eq $($OnlineModule.Version)}) {
                    IF ($Uninstall.IsPresent) {
                        Uninstall-Module -Name $($Module.Name) -RequiredVersion $($Module.Version) -Force
                    }
                }
                ELSE {
                    Write-Error -Message "[ERR] New module installation not found, check $($Module.Name)"
                }
            }
            ELSE {
                # Module update completed
            }
        }
    }
    END {
    }
}