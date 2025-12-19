# Set corporate lockscreen
# Runs as SYSTEM

try {
    # Create company folder if it doesn't exist
    $CompanyFolder = "C:\ProgramData\it2grow"
    if (!(Test-Path $CompanyFolder)) {
        New-Item -Path $CompanyFolder -ItemType Directory -Force | Out-Null
        Write-Output "Created company folder: $CompanyFolder"
    }
    
    # Download corporate lockscreen
    $LockscreenUrl = "https://stit2growintuneweu001.blob.core.windows.net/intune-assets/lockscreen.png"
    $LocalLockscreen = "C:\ProgramData\it2grow\lockscreen.png"
    
    Invoke-WebRequest -Uri $LockscreenUrl -OutFile $LocalLockscreen -UseBasicParsing -ErrorAction Stop
    Write-Output "Lockscreen downloaded: $LocalLockscreen"
    
    # Set lockscreen via registry (machine-level)
    $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    if (!(Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $RegPath -Name "LockScreenImage" -Value $LocalLockscreen -Force
    Set-ItemProperty -Path $RegPath -Name "PersonalColors_Background" -Value "#000000" -Force
    
    Write-Output "Lockscreen policy registry updated"
    
    Write-Output "Lockscreen applied successfully"
    exit 0
    
} catch {
    Write-Output "Error: $_"
    exit 1
}
