# Check if lockscreen is set

try {
    $LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
    $ExpectedHash = "66CA5CBE583CC8C3FCC5F4DD7CC5D925E0CB938C10EC8622A884E930C9C5DC1B"
    
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
