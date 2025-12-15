# Detection script for Windows 11 bloatware
# Returns exit code 1 if bloatware is found

$BloatwareApps = @(
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Clipchamp.Clipchamp"
    "BytedancePte.Ltd.TikTok"
    "Facebook.Instagram"
    "SpotifyAB.SpotifyMusic"
    "Disney.37853FC22B2CE"
    "Microsoft.LinkedIn"
    "Microsoft.BingNews"
    "Microsoft.BingWeather"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Getstarted"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.GetHelp"
    "Microsoft.MixedReality.Portal"
    "Microsoft.People"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.Todos"
    "microsoft.windowscommunicationsapps"
)

$FoundApps = @()

foreach ($App in $BloatwareApps) {
    $InstalledApp = Get-AppxPackage -Name $App -AllUsers -ErrorAction SilentlyContinue
    if ($InstalledApp) {
        $FoundApps += $App
    }
    
    # Also check provisioned apps
    $ProvisionedApp = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq $App }
    if ($ProvisionedApp -and $App -notin $FoundApps) {
        $FoundApps += $App
    }
}

if ($FoundApps.Count -gt 0) {
    Write-Output "Bloatware found: $($FoundApps -join ', ')"
    exit 1
} else {
    Write-Output "No bloatware found"
    exit 0
}
