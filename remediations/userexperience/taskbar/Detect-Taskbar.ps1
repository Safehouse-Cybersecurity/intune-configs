# Detection script for taskbar settings

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

$taskbarGlom = Get-ItemProperty -Path $regPath -Name "TaskbarGlomLevel" -ErrorAction SilentlyContinue
$mmTaskbar = Get-ItemProperty -Path $regPath -Name "MMTaskbarMode" -ErrorAction SilentlyContinue
$mmTaskbarGlom = Get-ItemProperty -Path $regPath -Name "MMTaskbarGlomLevel" -ErrorAction SilentlyContinue

# Expected values:
# TaskbarGlomLevel = 1 (Combine when taskbar is full)
# MMTaskbarMode = 2 (Taskbar where window is open)
# MMTaskbarGlomLevel = 1 (Combine when taskbar is full on other taskbars)

if ($taskbarGlom.TaskbarGlomLevel -eq 1 -and $mmTaskbar.MMTaskbarMode -eq 2 -and $mmTaskbarGlom.MMTaskbarGlomLevel -eq 1) {
    Write-Output "Taskbar settings are correct"
    exit 0
} else {
    Write-Output "Taskbar settings need remediation"
    exit 1
}
