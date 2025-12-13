# Detection script for corporate wallpaper
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$WallpaperPath = "C:\Windows\Web\Wallpaper\wallpaper.png"
$ExpectedHash = "130DEFF3C1AD30AF11CF7BA626AAF561A5A0A5E83F3DFA9E863BE1DED92871F4"

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
