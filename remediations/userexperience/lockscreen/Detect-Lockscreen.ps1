# Detection script for corporate lock screen
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$LockscreenPath = "C:\Windows\Web\Screen\lockscreen.png"
$ExpectedHash = "594133EEFEB66FAC22125388EE6B9888E6F8DFAA362595FDA35BAD1A7C9B4FA2"

if (Test-Path $LockscreenPath) {
    $CurrentHash = (Get-FileHash -Path $LockscreenPath -Algorithm SHA256).Hash
    if ($CurrentHash -eq $ExpectedHash) {
        Write-Output "Lockscreen is current"
        exit 0
    } else {
        Write-Output "Lockscreen outdated"
        exit 1
    }
} else {
    Write-Output "Lockscreen not found"
    exit 1
}
