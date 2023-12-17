FUNCTION Get-DotNetInstalls {
    <#
        .DESCRIPTION
        Lists installed .NET Framework and .NET Core installations.
        .FUNCTIONALITY
        Developed to provide a quick method to retrieve installed .NET packages.
        .EXAMPLE
        PS> Get-DotNetInstalls
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    BEGIN {
        $DotNet = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'
        $DotNetCore = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Updates\.NET'

        $ReturnData = @()
    }
    PROCESS {
        # DotNetCore Check
        IF (Test-Path -Path $DotNetCore -ErrorAction SilentlyContinue) {
            $DotNETCoreItems = Get-Item -Path $DotNetCore
            $ReturnData += $DotNetCoreItems.GetSubKeyNames() | Where-Object { $_ -match 'Microsoft ASP.NET' -or $_ -match 'Microsoft .NET' }
        }

        # DotNet Full Check
        IF (Test-Path -Path $DotNet) {
            $ReturnData += Get-ChildItem -Path $DotNet -Recurse | Get-ItemProperty -Name Version, InstallPath -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -Match 'Full' } | Select-Object Version, InstallPath | ForEach-Object {
                If ($_.InstallPath -like '*Framework64*') {
                    "Microsoft .NET Framework Full (x64) $($_.Version)"
                }
                ELSE {
                    "Microsoft .NET Framework Full (x86) $($_.Version)"
                }
            }
        }
        # DotNET Client Check
        IF (Test-Path -Path $DotNet) {
            $ReturnData += Get-ChildItem -Path $DotNet -Recurse | Get-ItemProperty -Name Version, InstallPath -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -Match 'Client' } | Select-Object Version, InstallPath | ForEach-Object {
                If ($_.InstallPath -like '*Framework64*') {
                    "Microsoft .NET Framework Client (x64) $($_.Version)"
                }
                ELSE {
                    "Microsoft .NET Framework Client (x86) $($_.Version)"
                }
            }
        }
    }
    END {
        RETURN $ReturnData
    }
}