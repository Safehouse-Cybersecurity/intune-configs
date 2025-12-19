# Set corporate lockscreen
# Runs as SYSTEM

try {
    # Create company folder
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created folder: $CompanyFolder"
    }
    
    # Download corporate lockscreen
    $LockscreenUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/lockscreen.png"
    $LocalLockscreen = "C:\ProgramData\it2grow\lockscreen.png"
    
    Invoke-WebRequest -Uri $LockscreenUrl -OutFile $LocalLockscreen -UseBasicParsing -ErrorAction Stop
    Write-Output "Lockscreen downloaded: $LocalLockscreen"
    
    # Set lockscreen via HKLM (machine-level, works for all users)
    $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    if (!(Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $RegPath -Name "LockScreenImage" -Value $LocalLockscreen -Force
    
    Write-Output "Lockscreen remediation completed successfully"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    Write-Output "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
