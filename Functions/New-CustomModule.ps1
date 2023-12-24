FUNCTION New-CustomModule {
    <#
        .DESCRIPTION
        Deploys out file and folder structure to build a new module with function files.
        .FUNCTIONALITY
        Developed to quickly package function files into a module.
        .PARAMETER Name
        [string] Name of the module to create.
        .PARAMETER Version
        [string] Version of your module.
        .PARAMETER Path
        [System.IO.FileInfo] Root location which contains versions.txt file.
        .PARAMETER Description
        [string] Basic description of your module.
        .PARAMETER Author
        [switch] Who made it.
        .PARAMETER CompanyName
        [switch] Again, who made it.
        .PARAMETER PowerShellVersion
        [string] Minimum version of PowerShell required to run.
        .EXAMPLE
        PS> New-CustomModule -Name 'Test-Module' -Version 1.0 -Path 'D:\Modules' -Description 'Test module for something'
        .EXAMPLE
        PS> New-CustomModule -Name 'Test-Module' -Version 1.0 -Path 'D:\Modules' -Description 'Test module for something' -Author 'Me'
        .NOTES
        Author: Adam Branham (https://github.com/HSVAdam)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [ValidateScript({ IF ( -Not ($_ | Test-Path) ) { THROW "$_ not found." } RETURN $true })]
        [System.IO.FileInfo]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [string]$Author = 'Adam Branham',
        [Parameter(Mandatory = $false)]
        [string]$CompanyName = '',
        [Parameter(Mandatory = $false)]
        [string]$PowerShellVersion = '5.1',
        [Parameter(Mandatory = $false)]
        [string[]]$PSEditions = @('Desktop', 'Core')
    )

    # Build directory structure
    IF (!(Test-Path -Path "$Path\$Name")) { New-Item -Path "$Path\$Name" -ItemType Directory | Out-Null }
    IF (!(Test-Path -Path "$Path\$Name\public")) { New-Item -Path "$Path\$Name\public" -ItemType Directory | Out-Null }
    IF (!(Test-Path -Path "$Path\$Name\private")) { New-Item -Path "$Path\$Name\private" -ItemType Directory | Out-Null }

    # Create file with utf8 encoding and add command to pull ps1 files
    Out-File -FilePath "$Path\$Name\$Name.psm1" -Encoding 'utf8'
    Add-Content -Path "$Path\$Name\$Name.psm1" -Value 'Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -Exclude *.tests.ps1, *profile.ps1 | ForEach-Object { . $_.FullName }'
    # Build manifest file
    $Params = @{
        'Path'                 = "$Path\$Name\$Name.psd1"
        'Author'               = $Author
        'ModuleVersion'        = $Version
        'CompanyName'          = $CompanyName
        'RootModule'           = "$Name.psm1"
        'PowerShellVersion'    = $PowerShellVersion
        'CompatiblePSEditions' = $PSEditions
        'FunctionsToExport'    = $null
        'CmdletsToExport'      = @()
        'VariablesToExport'    = ''
        'AliasesToExport'      = @()
        'Description'          = $Description
    }
    New-ModuleManifest @Params

    Write-Host "Module setup at: $Path\$Name"
    Write-Host "Copy your function files to public folder and modify $Name.psd1 file if you like."
}