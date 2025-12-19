# Set corporate wallpaper and disable Spotlight
# Runs as SYSTEM - must target the actual logged-in user's registry

try {
    # Get the current logged-in user
    $LoggedInUser = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName)
    
    if (!$LoggedInUser) {
        Write-Output "No user logged in"
        exit 1
    }
    
    # Extract username
    $Username = $LoggedInUser.Split('\')[1]
    Write-Output "Logged-in user: $Username"
    
    # Get user SID
    $UserSID = (New-Object System.Security.Principal.NTAccount($Username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
    Write-Output "User SID: $UserSID"
    
    # Load HKU registry if not already loaded
    if (!(Test-Path "HKU:\")) {
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
    }
    
    # Create company folder
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created folder: $CompanyFolder"
    }
    
    # Disable Windows Spotlight for this user
    $CDMPath = "HKU:\$UserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    
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
    
    Write-Output "Spotlight disabled for user $Username"
    
    # Download corporate wallpaper
    $WallpaperUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/wallpaper.png"
    $LocalWallpaper = "C:\ProgramData\it2grow\wallpaper.png"
    
    Invoke-WebRequest -Uri $WallpaperUrl -OutFile $LocalWallpaper -UseBasicParsing -ErrorAction Stop
    Write-Output "Wallpaper downloaded: $LocalWallpaper"
    
    # Set wallpaper for this user
    $DesktopPath = "HKU:\$UserSID\Control Panel\Desktop"
    Set-ItemProperty -Path $DesktopPath -Name "Wallpaper" -Value $LocalWallpaper -Force
    Set-ItemProperty -Path $DesktopPath -Name "WallpaperStyle" -Value "10" -Type String -Force
    Set-ItemProperty -Path $DesktopPath -Name "TileWallpaper" -Value "0" -Type String -Force
    
    Write-Output "Wallpaper set for user $Username"
    
    # Force wallpaper update (kill Explorer to reload)
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    
    Write-Output "Wallpaper remediation completed successfully"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    Write-Output "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
