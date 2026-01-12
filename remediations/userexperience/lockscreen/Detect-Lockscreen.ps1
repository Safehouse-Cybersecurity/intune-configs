# Check if lockscreen is set

try {
    $LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
    $ExpectedHash = "A8AF5BD0A9358108A2535445BFA0E20E69AA5BB8F4039EFBD5110FC72A640B84"
    
    if (!(Test-Path $LockscreenPath)) {
        Write-Output "File missing"
        exit 1
    }
    
    $CurrentHash = (Get-FileHash -Path $LockscreenPath -Algorithm SHA256).Hash
    if ($CurrentHash -ne $ExpectedHash) {
        Write-Output "Hash mismatch"
        exit 1
    }
    
    Write-Output "Compliant"
    exit 0
    
} catch {
    Write-Output "ERROR: $_"
    exit 1
}
