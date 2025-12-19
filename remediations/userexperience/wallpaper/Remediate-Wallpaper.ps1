# Set corporate wallpaper and disable Spotlight
# Runs as SYSTEM

try {
    # Create company folder if it doesn't exist
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created company folder: $CompanyFolder"
    }
    
    # Disable Windows Spotlight completely
    $CDMPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    
    $SpotlightSettings = @{
        "RotatingLockScreenEnabled" = 0
        "RotatingLockScreenOverlayEnabled" = 0
        "SubscribedContent-338387Enabled" = 0
        "SubscribedContent-338388Enabled" = 0
        "SubscribedContent-338389Enabled" = 0
        "SubscribedContent-338393Enabled" = 0
        "SubscribedContent-353694Enabled" = 0
        "SubscribedContent-353696Enabled" = 0
        "SystemPaneSuggestionsEnabled" = 0
        "SoftLandingEnabled" = 0
    }
    
    foreach ($Setting in $SpotlightSettings.GetEnumerator()) {
        Set-ItemProperty -Path $CDMPath -Name $Setting.Key -Value $Setting.Value -Type DWord -Force -ErrorAction SilentlyContinue
    }
    
    Write-Output "Spotlight disabled"
    
    # Download corporate wallpaper
    $WallpaperUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/wallpaper.png"
    $LocalWallpaper = "C:\ProgramData\it2grow\wallpaper.png"
    
    Invoke-WebRequest -Uri $WallpaperUrl -OutFile $LocalWallpaper -UseBasicParsing -ErrorAction Stop
    Write-Output "Wallpaper downloaded: $LocalWallpaper"
    
    # Set wallpaper
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value $LocalWallpaper -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "10" -Type String -Force  # Fill
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -Value "0" -Type String -Force
    
    Write-Output "Wallpaper registry updated"
    
    # Force refresh
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $LocalWallpaper, 0x0001 -bor 0x0002)
    
    Write-Output "Wallpaper applied successfully"
    exit 0
    
} catch {
    Write-Output "Error: $_"
    exit 1
}
