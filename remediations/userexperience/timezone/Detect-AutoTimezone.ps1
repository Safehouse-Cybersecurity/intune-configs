# Detection script for automatic time zone and 24-hour lock screen time format

$compliant = $true

# Check automatic time zone
$tzAutoUpdate = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -ErrorAction SilentlyContinue

if ($tzAutoUpdate.Start -ne 3) {
    Write-Output "Automatic time zone is not enabled"
    $compliant = $false
} else {
    Write-Output "Automatic time zone is enabled"
}

# Check 24-hour time format for lock screen
try {
    $regPath = "Registry::HKEY_USERS\.DEFAULT\Control Panel\International"
    $shortTime = Get-ItemPropertyValue -Path $regPath -Name "sShortTime" -ErrorAction Stop
    $timeFormat = Get-ItemPropertyValue -Path $regPath -Name "sTimeFormat" -ErrorAction Stop
    
    if ($shortTime -ne "HH:mm" -or $timeFormat -ne "HH:mm:ss") {
        Write-Output "24-hour time format not configured (current: $shortTime / $timeFormat)"
        $compliant = $false
    } else {
        Write-Output "24-hour time format is configured"
    }
} catch {
    Write-Output "Failed to read time format registry: $_"
    $compliant = $false
}

# Exit based on compliance
if ($compliant) {
    exit 0
} else {
    exit 1
}
