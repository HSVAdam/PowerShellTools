FUNCTION Copy-FolderStructure {
    <#
        .DESCRIPTION
        Exactly replicates a folder structure from source to destination with no files.
        .FUNCTIONALITY
        Developed to clone log folder structure in a new location.
        .PARAMETER Source
        The source folder to clone.
        .PARAMETER Destination
        The blank destination folder to build source structure.
        .EXAMPLE
        PS> Copy-FolderStructure -Source C:\Logs -Destination D:\
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
        [string]$Destination
    )
    BEGIN {

    }
    PROCESS {
        TRY {
            Get-ChildItem $Source -Recurse | Where-Object { $_.PSIsContainer } | ForEach-Object {
                $TargetFolder = $Destination + $_.FullName.SubString($Source.Length);
                New-Item -ItemType Directory -Path $TargetFolder -Force;
            }
        }
        CATCH {
            $Error[0]
        }
    }
    END {

    }
}