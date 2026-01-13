# Remediation script for automatic time zone and 24-hour lock screen time format

$success = $true

# Enable automatic time zone
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -Value 3
    Start-Service -Name "tzautoupdate" -ErrorAction SilentlyContinue
    Write-Output "Automatic time zone enabled successfully"
} catch {
    Write-Output "Failed to enable automatic time zone: $_"
    $success = $false
}

# Set 24-hour time format for lock screen
try {
    $regPath = "Registry::HKEY_USERS\.DEFAULT\Control Panel\International"
    
    Set-ItemProperty -Path $regPath -Name "sShortTime" -Value "HH:mm" -Type String
    Set-ItemProperty -Path $regPath -Name "sTimeFormat" -Value "HH:mm:ss" -Type String
    
    Write-Output "24-hour time format configured successfully"
} catch {
    Write-Output "Failed to set 24-hour time format: $_"
    $success = $false
}

# Exit based on success
if ($success) {
    exit 0
} else {
    exit 1
}
