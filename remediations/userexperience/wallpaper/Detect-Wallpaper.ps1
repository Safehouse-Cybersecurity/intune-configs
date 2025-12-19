# Check if corporate wallpaper is set

try {
    $WallpaperPath = "C:\ProgramData\it2grow\wallpaper.png"
    $ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"
    
    # Find logged-in user's SID via explorer.exe process
    $LoggedInUserSID = $null
    $ExplorerProcess = Get-WmiObject -Class Win32_Process -Filter "Name='explorer.exe'"
    
    if ($ExplorerProcess) {
        $ExplorerOwner = $ExplorerProcess.GetOwner()
        $Username = $ExplorerOwner.User
        
        # Load HKU
        if (!(Test-Path "HKU:\")) {
            New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
        }
        
        # Find SID
        Get-ChildItem "HKU:\" | Where-Object { $_.Name -match 'S-1-5-21' } | ForEach-Object {
            $SID = $_.PSChildName
            $ProfilePath = "HKU:\$SID\Volatile Environment"
            
            if (Test-Path $ProfilePath) {
                $ProfileUser = (Get-ItemProperty -Path $ProfilePath -ErrorAction SilentlyContinue).USERNAME
                if ($ProfileUser -eq $Username) {
                    $LoggedInUserSID = $SID
                }
            }
        }
    }
    
    if (!$LoggedInUserSID) {
        Write-Output "No logged-in user found"
        exit 1
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
    $DesktopPath = "HKU:\$LoggedInUserSID\Control Panel\Desktop"
    $CurrentWallpaper = (Get-ItemProperty -Path $DesktopPath -ErrorAction SilentlyContinue).Wallpaper
    
    if ($CurrentWallpaper -ne $WallpaperPath) {
        Write-Output "Wallpaper not set: $CurrentWallpaper"
        exit 1
    }
    
    # Check Spotlight
    $CDMPath = "HKU:\$LoggedInUserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $CDM = Get-ItemProperty -Path $CDMPath -ErrorAction SilentlyContinue
    
    if ($CDM.RotatingLockScreenEnabled -ne 0 -or $CDM.RotatingLockScreenOverlayEnabled -ne 0) {
        Write-Output "Spotlight still enabled"
        exit 1
    }
    
    Write-Output "Compliant"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    exit 1
}
