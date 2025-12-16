# Remediation script for custom local admin account
# Creates it2gadmin account and disables built-in Administrator

$CustomAdmin = "it2gadmin"
$CustomAdminDescription = "Managed local administrator account"

try {
    # Check if custom admin already exists
    $ExistingAccount = Get-LocalUser -Name $CustomAdmin -ErrorAction SilentlyContinue
    
    if (-not $ExistingAccount) {
        # Generate a random temporary password (LAPS will manage the real password)
        $TempPassword = -join ((48..57) + (65..90) + (97..122) + (33..47) | Get-Random -Count 24 | ForEach-Object {[char]$_})
        $SecurePassword = ConvertTo-SecureString $TempPassword -AsPlainText -Force
        
        # Create the custom admin account
        New-LocalUser -Name $CustomAdmin -Password $SecurePassword -Description $CustomAdminDescription -PasswordNeverExpires $true -AccountNeverExpires -ErrorAction Stop
        Write-Output "Created local admin account: $CustomAdmin"
        
        # Add to Administrators group
        Add-LocalGroupMember -Group "Administrators" -Member $CustomAdmin -ErrorAction Stop
        Write-Output "Added $CustomAdmin to Administrators group"
    } else {
        Write-Output "Custom admin account already exists"
    }
    
    # Disable built-in Administrator account
    $BuiltInAdmin = Get-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
    if ($BuiltInAdmin -and $BuiltInAdmin.Enabled -eq $true) {
        Disable-LocalUser -Name "Administrator" -ErrorAction Stop
        Write-Output "Disabled built-in Administrator account"
    } else {
        Write-Output "Built-in Administrator already disabled"
    }
    
    exit 0
} catch {
    Write-Output "Failed: $_"
    exit 1
}
