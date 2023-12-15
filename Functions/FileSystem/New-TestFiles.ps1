FUNCTION New-TestFiles {
    <#
        .DESCRIPTION
        Creates files used for testing purposes.
        .FUNCTIONALITY
        Developed to test file based actions using test files of specificed size.
        .PARAMETER FileName
        Base name of files to be created.
        .PARAMETER FileExtension
        Extension to use for test files.
        .PARAMETER Count
        Number of files to create.
        .PARAMETER Size
        The size of the files to create.  Default is 1MB.
        .PARAMETER Directory
        Location to create test files. Default is current location.
        .EXAMPLE
        PS> New-TestFiles -FileName 'Test' -FileExtension 'txt' -Count 50 -Size '1MB' -Directory 'C:\TestData'
        .EXAMPLE
        PS> New-TestFiles -FileName 'Test' -FileExtension 'txt' -Count 50
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FileName,
        [Parameter(Mandatory = $true)]
        [string]$FileExtension,
        [Parameter(Mandatory = $true)]
        [int]$Count,
        [Parameter(Mandatory = $false)]
        [string]$Size = '1MB',
        [Parameter(Mandatory = $false)]
        [ValidateScript({ IF ( -Not ($_ | Test-Path) ) { THROW 'File or folder does not exist' } RETURN $true })]
        [string]$Directory = (Get-Location)
    )
    BEGIN {

    }
    PROCESS {
        TRY {
            FOR ($i = 1; $i -le $Count; $i++) {
                $File = New-Object System.IO.FileStream "$Directory\$FileName-$i.$FileExtension", Create, ReadWrite
                $File.SetLength($Size)
                $File.Close()
            }
        }
        CATCH {
            $Error[0]
        }
    }
    END {

    }
}