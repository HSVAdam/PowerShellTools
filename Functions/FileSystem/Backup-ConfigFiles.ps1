FUNCTION Backup-ConfigFiles {
    <#
        .DESCRIPTION
        Perform backup of important configuration files while maintaining folder structure.
        .FUNCTIONALITY
        Developer to backup web.config and appsettings.json configurations of an IIS setup.
        .PARAMETER Source
        Root path to begin file collection.
        .PARAMETER Destination
        Root path to clone source folder structure and files.
        .PARAMETER Files
        Array of folder names to exclude, this includes the entire contents of folder as well. Default value is @('*.config', 'appsettings.json').
        .EXAMPLE
        PS> Backup-ConfigFiles -Source 'D:\inetpub\wwwroot' -Destination 'E:\Backups'
        .EXAMPLE
        PS> Backup-ConfigFiles -Source 'D:\inetpub\wwwroot' -Destination 'E:\Backups' -Files @('*.config', 'appsettings.json')
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ IF (Test-Path $_) { $true } ELSE { THROW "Path $_ is not valid" } })]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ IF (Test-Path $_) { $true } ELSE { THROW "Path $_ is not valid" } })]
        [string]$Destination,
        [Parameter(Mandatory = $false)]
        [string[]]$Files = @('*.config', 'appsettings.json')
    )
    BEGIN {

    }
    PROCESS {
        TRY {
            Get-ChildItem -Path $Source -Recurse -Include $Files | ForEach-Object {
                $TargetFile = $Destination + $_.FullName.SubString($Source.Length)
                New-Item -Path $TargetFile -ItemType File -Force
                Copy-Item $_.FullName -Destination $TargetFile
            }
        }
        CATCH {
            $Error[0]
        }
    }
    END {

    }

}