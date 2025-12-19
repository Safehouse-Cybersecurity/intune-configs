# Check if lockscreen is set

try {
    $LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
    $ExpectedHash = "894A38D9C64A634A827E75FF1DE09B95C58449B778EE310C81A262A9027DCAA6"
    
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
