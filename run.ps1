Function Install-Packages {

    $modules = @("Az", "Az.Security", "Pester")
    
    if (Get-PSRepository -Name "PSGallery") {
        Write-Verbose "$(Get-TimeStamp) PSGallery already registered"
    } 
    else {
        Write-Information "$(Get-TimeStamp) Registering PSGallery"
        Register-PSRepository -Default
    }

    foreach ($module in $modules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-Verbose "$(Get-TimeStamp) $module already installed"
        } 
        else {
            Write-Information "$(Get-TimeStamp) Installing $module"
            Install-Module $module -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction Stop | Out-Null
            Import-Module $module -Force -Scope Local | Out-Null
        }
    }

    Write-Host "Suppressing Az.Security warning message"
    Set-Item env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
}

$PSVersionTable
$ErrorActionPreference = "stop"
Get-Location

Write-Host "Invoking Pester"
Invoke-Pester -Script @{
    Path             = "./tests.ps1"
} `
-OutputFile ./output.xml `
-OutputFormat NUnitXML
