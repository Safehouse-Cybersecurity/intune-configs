# Detection script for corporate wallpaper
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$WallpaperPath = "C:\Windows\Web\Wallpaper\wallpaper.png"
$ExpectedHash = "C309CB12E617275468940793F402FB23469A11956A4EFB8BC28BF38D94A5301D"

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
