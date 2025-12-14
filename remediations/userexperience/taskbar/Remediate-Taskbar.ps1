# Remediation script for taskbar settings
# Sets TaskbarGlomLevel and MMTaskbarMode

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

try {
    # TaskbarGlomLevel: 0 = Always combine, 1 = Combine when full, 2 = Never combine
    Set-ItemProperty -Path $regPath -Name "TaskbarGlomLevel" -Value 1 -Type DWord -Force
    
    # MMTaskbarMode: 0 = All taskbars, 1 = Main and where open, 2 = Where open only
    Set-ItemProperty -Path $regPath -Name "MMTaskbarMode" -Value 0 -Type DWord -Force
    
    # Restart Explorer to apply changes
    Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
    Start-Process "explorer.exe"
    
    Write-Output "Taskbar settings applied successfully"
    exit 0
} catch {
    Write-Output "Failed to apply taskbar settings: $_"
    exit 1
}
