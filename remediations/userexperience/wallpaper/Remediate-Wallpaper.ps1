# Set corporate wallpaper and disable Spotlight
# Runs as SYSTEM - Azure AD compatible

try {
    # Method 1: Get currently logged-in user's SID from registry
    $LoggedInUserSID = $null
    
    # Find the SID of the user who owns explorer.exe process (= logged-in user)
    $ExplorerProcess = Get-WmiObject -Class Win32_Process -Filter "Name='explorer.exe'"
    if ($ExplorerProcess) {
        $ExplorerOwner = $ExplorerProcess.GetOwner()
        $Username = $ExplorerOwner.User
        $Domain = $ExplorerOwner.Domain
        
        Write-Output "Found user: $Domain\$Username"
        
        # Load HKU registry
        if (!(Test-Path "HKU:\")) {
            New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS -ErrorAction SilentlyContinue | Out-Null
        }
        
        # Find user's SID by enumerating HKU and matching username
        Get-ChildItem "HKU:\" | Where-Object { $_.Name -match 'S-1-5-21' } | ForEach-Object {
            $SID = $_.PSChildName
            $ProfilePath = "HKU:\$SID\Volatile Environment"
            
            if (Test-Path $ProfilePath) {
                $ProfileUser = (Get-ItemProperty -Path $ProfilePath -ErrorAction SilentlyContinue).USERNAME
                if ($ProfileUser -eq $Username) {
                    $LoggedInUserSID = $SID
                    Write-Output "Matched SID: $SID for user $Username"
                }
            }
        }
    }
    
    if (!$LoggedInUserSID) {
        Write-Output "ERROR: Could not find logged-in user's SID"
        exit 1
    }
    
    Write-Output "Using SID: $LoggedInUserSID"
    
    # Create company folder
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created folder: $CompanyFolder"
    }
    
    # Disable Windows Spotlight
    $CDMPath = "HKU:\$LoggedInUserSID\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    
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
    $DesktopPath = "HKU:\$LoggedInUserSID\Control Panel\Desktop"
    Set-ItemProperty -Path $DesktopPath -Name "Wallpaper" -Value $LocalWallpaper -Force
    Set-ItemProperty -Path $DesktopPath -Name "WallpaperStyle" -Value "10" -Type String -Force
    Set-ItemProperty -Path $DesktopPath -Name "TileWallpaper" -Value "0" -Type String -Force
    
    Write-Output "Wallpaper configured"
    
    # Kill Explorer to force refresh
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    
    Write-Output "SUCCESS: Wallpaper remediation complete"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    Write-Output "Stack: $($_.ScriptStackTrace)"
    exit 1
}
