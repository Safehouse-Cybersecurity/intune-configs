# Check if lockscreen is set

try {
    $LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
    $ExpectedHash = "CBDFAF6F37E69BC4A80F31626827BD6AA7220EC531919BCCB1CB112E6EE5985F"
    
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
