FUNCTION ConvertTo-UNCPath {
    <#
        .DESCRIPTION
        Converts supplied path to a UNC path.
        .FUNCTIONALITY
        Developed to convert a local path to a UNC path for automation.
        .PARAMETER Path
        Path to convert.
        .PARAMETER ComputerName
        Name of device holding the network share. Default is $env:COMPUTERNAME.
        .EXAMPLE
        PS> ConvertTo-UNCPath -Path 'D:\inetpub\wwwroot'
        .EXAMPLE
        PS> $UNCPath = ConvertTo-UNCPath -Path 'D:\inetpub\wwwroot' -ComputerName 'IISServer'
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME
    )
    BEGIN {

    }
    PROCESS {
        TRY {
            $PathRoot = $Path | Split-Path -Qualifier
            IF ((([System.IO.DriveInfo]($PathRoot)).DriveType -ne 'Network')) {
                $Result = ("\\$($ComputerName)$(($Path).Replace($PathRoot, "\$($Path[0])$"))")
            }
            ELSE {
                $Result = 'Network Drive'
            }
        }
        CATCH {
            Write-Error $Error[0]
        }
    }
    END {
        RETURN $Result
    }
}