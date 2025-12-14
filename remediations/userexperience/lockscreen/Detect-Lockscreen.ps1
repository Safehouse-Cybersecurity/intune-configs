# Detection script for corporate lock screen
# Returns exit code 0 if compliant, exit code 1 if remediation needed

$LockscreenPath = "C:\Windows\Web\Screen\lockscreen.png"
$ExpectedHash = "130DEFF3C1AD30AF11CF7BA626AAF561A5A0A5E83F3DFA9E863BE1DED92871F4"

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
