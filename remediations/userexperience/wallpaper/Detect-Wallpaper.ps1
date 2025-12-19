# Check if corporate wallpaper is set
# Azure AD compatible

try {
    $WallpaperPath = "C:\ProgramData\it2grow\wallpaper.png"
    $ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"
    
    # Determine if running as SYSTEM
    $CurrentSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $RunningAsSystem = $CurrentSID -eq 'S-1-5-18'
    
    if ($RunningAsSystem) {
        # Running as SYSTEM - find user's registry hive
        if (!(Test-Path "HKU:\")) {
            New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
        }
        
        # Look for S-1-5-21 (domain) or S-1-12-1 (Azure AD)
        $UserSID = Get-ChildItem "HKU:\" -ErrorAction SilentlyContinue | 
            Where-Object { 
                ($_.Name -match 'S-1-5-21' -or $_.Name -match 'S-1-12-1') -and 
                (Test-Path "HKU:\$($_.PSChildName)\Volatile Environment") 
            } |
            Sort-Object -Property @{Expression={$_.LastWriteTime}; Descending=$true} |
            Select-Object -First 1 -ExpandProperty PSChildName
        
        if (!$UserSID) {
            Write-Output "No user SID found"
            exit 1
        }
        
        $DesktopPath = "HKU:\$UserSID\Control Panel\Desktop"
        $CDMPath = "HKU:\$UserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        
    } else {
        # Running as current user
        $DesktopPath = "HKCU:\Control Panel\Desktop"
        $CDMPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    }
    
    # Check file exists
    if (!(Test-Path $WallpaperPath)) {
        Write-Output "Wallpaper file missing"
        exit 1
    }
    
    # Check hash
    $CurrentHash = (Get-FileHash -Path $WallpaperPath -Algorithm SHA256).Hash
    if ($CurrentHash -ne $ExpectedHash) {
        Write-Output "Hash mismatch"
        exit 1
    }
    
    # Check wallpaper setting
    $CurrentWallpaper = (Get-ItemProperty -Path $DesktopPath -ErrorAction SilentlyContinue).Wallpaper
    if ($CurrentWallpaper -ne $WallpaperPath) {
        Write-Output "Wallpaper not set: $CurrentWallpaper"
        exit 1
    }
    
    # Check Spotlight
    $CDM = Get-ItemProperty -Path $CDMPath -ErrorAction SilentlyContinue
    if ($CDM.RotatingLockScreenEnabled -ne 0 -or $CDM.RotatingLockScreenOverlayEnabled -ne 0) {
        Write-Output "Spotlight enabled"
        exit 1
    }
    
    Write-Output "Compliant"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    exit 1
}
