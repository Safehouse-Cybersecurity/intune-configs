 Detection script for corporate wallpaper
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$WallpaperPath = "C:\Windows\Web\Wallpaper\wallpaper.png"

if (Test-Path $WallpaperPath) {
    Write-Output "Wallpaper exists"
    exit 0
} else {
    Write-Output "Wallpaper not found"
    exit 1
}
