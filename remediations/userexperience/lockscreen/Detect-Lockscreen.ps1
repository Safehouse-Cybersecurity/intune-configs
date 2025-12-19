# Check if lockscreen is set

try {
    $LockscreenPath = "C:\ProgramData\it2grow\lockscreen.png"
    $ExpectedHash = "21A26525B95C47DCE3D75FB32964D36DC97FCF5B53AF61E92D674457B862B767"
    
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
