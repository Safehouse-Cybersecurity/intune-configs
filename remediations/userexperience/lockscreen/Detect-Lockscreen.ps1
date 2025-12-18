# Detection script for corporate lock screen
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$LockscreenPath = "C:\Windows\Web\Screen\lockscreen.png"
$ExpectedHash = "FADE173C33F09A6E3AF3AD66E75275B3495E26149B4D38240BF96B604D3B1B2B"

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
