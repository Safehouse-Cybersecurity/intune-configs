# Detection script for corporate lock screen
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$LockscreenPath = "C:\Windows\Web\Screen\lockscreen.png"
$ExpectedHash = "71A16E44849AC3912656C2AC5B288FA5DFAA206F36D5FB94429ED8DAC4880D11"

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
