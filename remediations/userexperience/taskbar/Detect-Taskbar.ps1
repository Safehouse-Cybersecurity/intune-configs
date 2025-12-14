# Detection script for taskbar settings
# Checks TaskbarGlomLevel and MMTaskbarMode

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

$taskbarGlom = Get-ItemProperty -Path $regPath -Name "TaskbarGlomLevel" -ErrorAction SilentlyContinue
$mmTaskbar = Get-ItemProperty -Path $regPath -Name "MMTaskbarMode" -ErrorAction SilentlyContinue

# Expected values:
# TaskbarGlomLevel = 1 (Combine when taskbar is full)
# MMTaskbarMode = 0 (Show on all taskbars) - change if you want different

if ($taskbarGlom.TaskbarGlomLevel -eq 1 -and $mmTaskbar.MMTaskbarMode -eq 0) {
    Write-Output "Taskbar settings are correct"
    exit 0
} else {
    Write-Output "Taskbar settings need remediation"
    exit 1
}
