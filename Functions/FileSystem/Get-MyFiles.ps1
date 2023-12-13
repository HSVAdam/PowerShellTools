FUNCTION Get-MyFiles {
    <#
        .DESCRIPTION
        Performs an advanced Get-Childitem that allows exclusion of files and folders.
        .FUNCTIONALITY
        Developed to retrieve a collection of files and folders to backup from application; allowing exclusion of configuration files or log folders.
        .PARAMETER Path
        Root path to begin file collection.
        .PARAMETER xFiles
        Array of file names or extensions to exclude from results.
        .PARAMETER xFolders
        Array of folder names to exclude, this includes the entire contents of folder as well.
        .EXAMPLE
        PS> Get-MyFiles -Path 'D:\inetpub\wwwroot'
        .EXAMPLE
        PS> $Contents = Get-MyFiles -Path 'D:\inetpub\wwwroot' -xFiles @('thisfile.txt', '*.exe')
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ IF ( -Not ($_ | Test-Path) ) { THROW 'Path does not exist.' } RETURN $true })]
        [System.IO.FileInfo]$Path,
        [Parameter(Mandatory = $false)]
        [string[]]$xFiles = @('EXCLUDEFILE.TXT'),
        [Parameter(Mandatory = $false)]
        [string[]]$xFolders = @('EXCLUDEFOLDER')
    )
    BEGIN {
        # Build regular expression of folders to exclude
        [regex]$xFoldersRegEx = '(?i)' + (($xFolders | ForEach-Object { [regex]::escape($_) }) -join '|') + ''
    }
    PROCESS {
        $ReturnData = Get-ChildItem -Path $Path -Recurse -Exclude $xFiles | Where-Object { $null -eq $xFolders -or $_.FullName.Replace($Path.FullName, '') -notmatch $xFoldersRegEx }
    }
    END {
        RETURN $ReturnData
    }
}