# Check if corporate wallpaper is set and Spotlight is disabled

try {
    $WallpaperPath = "C:\ProgramData\it2grow\wallpaper.png"
    $ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"
    
    # Get current user
    $LoggedInUser = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName)
    if (!$LoggedInUser) {
        Write-Output "No user logged in"
        exit 1
    }
    
    $Username = $LoggedInUser.Split('\')[1]
    $UserSID = (New-Object System.Security.Principal.NTAccount($Username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
    
    # Load HKU if needed
    if (!(Test-Path "HKU:\")) {
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
    }
    
    # Check if wallpaper file exists
    if (!(Test-Path $WallpaperPath)) {
        Write-Output "Wallpaper file missing"
        exit 1
    }
    
    # Verify file hash
    $CurrentHash = (Get-FileHash -Path $WallpaperPath -Algorithm SHA256).Hash
    if ($CurrentHash -ne $ExpectedHash) {
        Write-Output "Wallpaper hash mismatch"
        exit 1
    }
    
    # Check wallpaper setting
    $DesktopPath = "HKU:\$UserSID\Control Panel\Desktop"
    $CurrentWallpaper = (Get-ItemProperty -Path $DesktopPath -ErrorAction SilentlyContinue).Wallpaper
    if ($CurrentWallpaper -ne $WallpaperPath) {
        Write-Output "Wallpaper not set correctly: $CurrentWallpaper"
        exit 1
    }
    
    # Check Spotlight
    $CDMPath = "HKU:\$UserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $CDM = Get-ItemProperty -Path $CDMPath -ErrorAction SilentlyContinue
    
    if ($CDM.RotatingLockScreenEnabled -ne 0 -or $CDM.RotatingLockScreenOverlayEnabled -ne 0) {
        Write-Output "Spotlight still enabled"
        exit 1
    }
    
    Write-Output "Wallpaper compliant"
    exit 0
    
} catch {
    Write-Output "ERROR in detection: $_"
    exit 1
}
