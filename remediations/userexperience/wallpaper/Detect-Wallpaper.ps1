# Detection script for corporate wallpaper
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$WallpaperPath = "C:\Windows\Web\Wallpaper\wallpaper.png"
$ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"

if (Test-Path $WallpaperPath) {
    $CurrentHash = (Get-FileHash -Path $WallpaperPath -Algorithm SHA256).Hash
    if ($CurrentHash -eq $ExpectedHash) {
        Write-Output "Wallpaper is current"
        exit 0
    } else {
        Write-Output "Wallpaper outdated"
        exit 1
    }
} else {
    Write-Output "Wallpaper not found"
    exit 1
}
