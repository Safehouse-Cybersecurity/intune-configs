# Check if corporate lockscreen is set

$LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
$ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"

# Check if lockscreen file exists
if (!(Test-Path $LockscreenPath)) {
    Write-Output "Lockscreen file missing"
    exit 1
}

# Verify file hash
$CurrentHash = (Get-FileHash -Path $LockscreenPath -Algorithm SHA256).Hash
if ($CurrentHash -ne $ExpectedHash) {
    Write-Output "Lockscreen file hash mismatch - needs update. Current: $CurrentHash"
    exit 1
}

Write-Output "Lockscreen compliant"
exit 0
