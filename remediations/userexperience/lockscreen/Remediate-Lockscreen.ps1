# Remediation script for corporate lock screen
# Downloads lock screen from Azure Blob Storage

$LockscreenUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/lockscreen.png"
$LockscreenPath = "C:\Windows\Web\Screen\lockscreen.png"

try {
    # Create directory if it doesn't exist
    $directory = Split-Path -Path $LockscreenPath -Parent
    if (!(Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    
    Invoke-WebRequest -Uri $LockscreenUrl -OutFile $LockscreenPath -UseBasicParsing
    Write-Output "Lockscreen downloaded successfully"
    exit 0
} catch {
    Write-Output "Failed to download lockscreen: $_"
    exit 1
}
