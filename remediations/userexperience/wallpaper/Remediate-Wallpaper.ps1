# Remediation script for corporate wallpaper
# Downloads wallpaper from Azure Blob Storage

$WallpaperUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/wallpaper.png"
$WallpaperPath = "C:\Windows\Web\Wallpaper\wallpaper.png"

try {
    Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath -UseBasicParsing
    Write-Output "Wallpaper downloaded successfully"
    exit 0
} catch {
    Write-Output "Failed to download wallpaper: $_"
    exit 1
}
