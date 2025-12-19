# Check if corporate wallpaper is set and Spotlight is disabled

$WallpaperPath = "C:\ProgramData\it2grow\wallpaper.png"
$ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"

# Check if wallpaper file exists
if (!(Test-Path $WallpaperPath)) {
    Write-Output "Wallpaper file missing"
    exit 1
}

# Check current wallpaper setting
$CurrentWallpaper = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -ErrorAction SilentlyContinue).Wallpaper
if ($CurrentWallpaper -ne $WallpaperPath) {
    Write-Output "Wallpaper not set correctly: $CurrentWallpaper"
    exit 1
}

# Check if Spotlight is disabled
$CDM = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -ErrorAction SilentlyContinue
if ($CDM.RotatingLockScreenEnabled -ne 0 -or $CDM.RotatingLockScreenOverlayEnabled -ne 0) {
    Write-Output "Spotlight still enabled"
    exit 1
}

# Verify file hash
$CurrentHash = (Get-FileHash -Path $WallpaperPath -Algorithm SHA256).Hash
if ($CurrentHash -ne $ExpectedHash) {
    Write-Output "Wallpaper file hash mismatch - needs update"
    exit 1
}

Write-Output "Wallpaper compliant"
exit 0
