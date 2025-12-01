#Requires -Version 5.1
<#
.SYNOPSIS
    Detects if Sophos Connect VPN provisioning file needs updating.
.DESCRIPTION
    Compares local cached .pro file with remote version on GitHub.
    Returns exit 1 (non-compliant) if update needed, exit 0 if current.
#>

$proUrl = "https://raw.githubusercontent.com/Safehouse-Cybersecurity/intune-configs/refs/heads/main/sophos/ra-vpn.pro"
$localFile = "C:\ProgramData\it2grow\sophos\ra-vpn.pro"
$sophosPath = "C:\Program Files (x86)\Sophos\Connect"

# Check if Sophos Connect is installed
if (-not (Test-Path $sophosPath)) {
    Write-Output "Sophos Connect not installed"
    exit 0
}

# Check if we have a cached copy
if (-not (Test-Path $localFile)) {
    Write-Output "No local config found"
    exit 1
}

try {
    $remoteContent = (Invoke-WebRequest -Uri $proUrl -UseBasicParsing).Content
    $localContent = Get-Content $localFile -Raw

    if ($remoteContent.Trim() -eq $localContent.Trim()) {
        Write-Output "Config is current"
        exit 0
    } else {
        Write-Output "Config outdated"
        exit 1
    }
} catch {
    Write-Output "Error checking config: $_"
    exit 1
}
