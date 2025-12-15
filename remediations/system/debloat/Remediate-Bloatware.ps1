# Remediation script for Windows 11 bloatware
# Removes unwanted AppX packages for all users and prevents reinstall

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

$RemovedCount = 0
$ErrorCount = 0

foreach ($App in $BloatwareApps) {
    # Remove provisioned package (prevents install for new users)
    $ProvisionedApp = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq $App }
    if ($ProvisionedApp) {
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $ProvisionedApp.PackageName -ErrorAction Stop
            Write-Output "Removed provisioned: $App"
        } catch {
            Write-Output "Failed to remove provisioned: $App - $_"
            $ErrorCount++
        }
    }

    # Remove installed package for all users
    $InstalledApp = Get-AppxPackage -Name $App -AllUsers -ErrorAction SilentlyContinue
    if ($InstalledApp) {
        try {
            $InstalledApp | Remove-AppxPackage -AllUsers -ErrorAction Stop
            Write-Output "Removed installed: $App"
            $RemovedCount++
        } catch {
            Write-Output "Failed to remove installed: $App - $_"
            $ErrorCount++
        }
    }
}

if ($ErrorCount -gt 0) {
    Write-Output "Completed with $ErrorCount errors. Removed $RemovedCount apps."
    exit 1
} else {
    Write-Output "Successfully removed $RemovedCount bloatware apps"
    exit 0
}
