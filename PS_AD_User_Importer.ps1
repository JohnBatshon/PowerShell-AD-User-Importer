# Specify the path to the text file containing usernames (one username per line)
$userListFilePath = "C:\Path\To\usernames.txt"

# Get the Active Directory "Users" group object
$group = Get-ADGroup "Users" -Server "Contoso"

if ($group -eq $null) {
    Write-Host "Group 'Users' not found in Active Directory."
    exit
}

# Read usernames from the text file
$usernames = Get-Content $userListFilePath

foreach ($username in $usernames) {
    # Check if the user exists in Active Directory
    $user = Get-ADUser $username -ErrorAction SilentlyContinue -Server "Contoso"

    if ($user -eq $null) {
        Write-Host "User '$username' not found in Active Directory. Adding user..."

        # Add the user to Active Directory
        $password = ConvertTo-SecureString "Password123!" -AsPlainText -Force
        $userParams = @{
            SamAccountName = $username
            Name = $username
            GivenName = $username
            Surname = "User"
            DisplayName = $username
            UserPrincipalName = "$username@contoso.com"
            Path = "OU=Users,DC=contoso,DC=com"
            AccountPassword = $password
            Enabled = $true
        }
        New-ADUser @userParams

        # Add the user to the "Users" group
        Add-ADGroupMember -Identity $group -Members $username
        if ($?) {
            Write-Host "User '$username' added to 'Users' group."
        } else {
            Write-Host "Failed to add user '$username' to 'Users' group."
        }
    } else {
        Write-Host "User '$username' already exists in Active Directory."
    }
}