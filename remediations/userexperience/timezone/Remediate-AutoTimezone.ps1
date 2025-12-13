# Remediation script for automatic time zone
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -Value 3
    Start-Service -Name "tzautoupdate" -ErrorAction SilentlyContinue
    Write-Output "Automatic time zone enabled successfully"
    exit 0
} catch {
    Write-Output "Failed to enable automatic time zone: $_"
    exit 1
}
