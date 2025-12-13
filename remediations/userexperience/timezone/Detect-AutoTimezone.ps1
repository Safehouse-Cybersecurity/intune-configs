# Detection script for automatic time zone
$tzAutoUpdate = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -ErrorAction SilentlyContinue

if ($tzAutoUpdate.Start -eq 3) {
    Write-Output "Automatic time zone is enabled"
    exit 0
} else {
    Write-Output "Automatic time zone is not enabled"
    exit 1
}
