# Set corporate wallpaper and disable Spotlight
# Azure AD compatible

try {
    # Determine if running as SYSTEM
    $CurrentSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $RunningAsSystem = $CurrentSID -eq 'S-1-5-18'
    
    if ($RunningAsSystem) {
        Write-Output "Running as SYSTEM"
        
        # Load HKU
        if (!(Test-Path "HKU:\")) {
            New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
        }
        
        # Find user SID - look for both S-1-5-21 (domain) and S-1-12-1 (Azure AD)
        $UserSID = Get-ChildItem "HKU:\" -ErrorAction SilentlyContinue | 
            Where-Object { 
                ($_.Name -match 'S-1-5-21' -or $_.Name -match 'S-1-12-1') -and 
                (Test-Path "HKU:\$($_.PSChildName)\Volatile Environment") 
            } |
            Sort-Object -Property @{Expression={$_.LastWriteTime}; Descending=$true} |
            Select-Object -First 1 -ExpandProperty PSChildName
        
        if (!$UserSID) {
            Write-Output "ERROR: No user SID found"
            exit 1
        }
        
        Write-Output "Target SID: $UserSID"
        $DesktopPath = "HKU:\$UserSID\Control Panel\Desktop"
        $CDMPath = "HKU:\$UserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        
    } else {
        Write-Output "Running as current user: $CurrentSID"
        $DesktopPath = "HKCU:\Control Panel\Desktop"
        $CDMPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    }
    
    # Create folder
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created: $CompanyFolder"
    }
    
    # Disable Spotlight
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
    
    # Download wallpaper
    $WallpaperUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/wallpaper.png"
    $LocalWallpaper = "C:\ProgramData\it2grow\wallpaper.png"
    
    Invoke-WebRequest -Uri $WallpaperUrl -OutFile $LocalWallpaper -UseBasicParsing -ErrorAction Stop
    Write-Output "Downloaded: $LocalWallpaper"
    
    # Set wallpaper
    Set-ItemProperty -Path $DesktopPath -Name "Wallpaper" -Value $LocalWallpaper -Force
    Set-ItemProperty -Path $DesktopPath -Name "WallpaperStyle" -Value "2" -Type String -Force
    Set-ItemProperty -Path $DesktopPath -Name "TileWallpaper" -Value "0" -Type String -Force
    Write-Output "Wallpaper configured"
    
    # Kill Explorer to force refresh
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    
    Write-Output "SUCCESS"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    exit 1
}
