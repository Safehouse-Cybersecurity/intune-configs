#Requires -Version 5.1
<#
.SYNOPSIS
    Downloads and imports Sophos Connect VPN provisioning file.
.DESCRIPTION
    Downloads .pro file from GitHub, caches it locally, and copies to 
    Sophos Connect import folder for automatic import.
#>

$proUrl = "https://raw.githubusercontent.com/Safehouse-Cybersecurity/intune-configs/refs/heads/main/sophos/ra-vpn.pro"
$cacheFolder = "C:\ProgramData\it2grow\sophos"
$localFile = "$cacheFolder\ra-vpn.pro"
$importPath = "C:\Program Files (x86)\Sophos\Connect\import"

try {
    # Wait for Sophos Connect service (max 2 min)
    $timeout = 120
    $timer = 0
    while ((Get-Service -Name scvpn -ErrorAction SilentlyContinue).Status -ne 'Running' -and $timer -lt $timeout) {
        Start-Sleep -Seconds 5
        $timer += 5
    }

    # Create cache folder if needed
    if (-not (Test-Path $cacheFolder)) {
        New-Item -Path $cacheFolder -ItemType Directory -Force | Out-Null
    }

    # Download latest .pro file
    Invoke-WebRequest -Uri $proUrl -OutFile $localFile -UseBasicParsing

    # Verify import folder exists
    if (-not (Test-Path $importPath)) {
        Write-Output "Sophos Connect import folder not found"
        exit 1
    }

    # Copy to Sophos Connect import folder (triggers auto-import)
    Copy-Item -Path $localFile -Destination $importPath -Force

    Write-Output "Config deployed successfully"
    exit 0
} catch {
    Write-Output "Failed to deploy config: $_"
    exit 1
}
