# Detection script for custom local admin account
# Checks if it2gadmin exists and built-in Administrator is disabled

$CustomAdmin = "it2gadmin"
$CustomAdminExists = $false
$BuiltInAdminDisabled = $false

# Check if custom admin account exists
try {
    $Account = Get-LocalUser -Name $CustomAdmin -ErrorAction Stop
    if ($Account) {
        $CustomAdminExists = $true
    }
} catch {
    $CustomAdminExists = $false
}

# Check if built-in Administrator is disabled
try {
    $BuiltInAdmin = Get-LocalUser -Name "Administrator" -ErrorAction Stop
    if ($BuiltInAdmin.Enabled -eq $false) {
        $BuiltInAdminDisabled = $true
    }
} catch {
    # Built-in Administrator not found (unlikely)
    $BuiltInAdminDisabled = $true
}

if ($CustomAdminExists -and $BuiltInAdminDisabled) {
    Write-Output "Custom admin exists and built-in Administrator is disabled"
    exit 0
} else {
    Write-Output "Remediation needed - CustomAdmin: $CustomAdminExists, BuiltInDisabled: $BuiltInAdminDisabled"
    exit 1
}
